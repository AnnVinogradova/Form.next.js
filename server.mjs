import { createServer } from 'node:http';
import { serve, send } from 'micro';

import getGenFunction, { _404 } from './pugrouter.mjs';
import { URLSearchParams } from 'node:url';
import { parse as parseCookie } from 'cookie';
import DB from './mydb.mjs';


const
	port = 3333,
	server = createServer(serve(async (request, response) => {
		console.log((new Date()).toLocaleTimeString(), request.method, request.url, 'HTTP/' + request.httpVersion);
		const
			genFunction = getGenFunction(request),
			postData = 'POST' === request.method ? await getAndParsePostBody(request) : null,
			cookies = parseCookie(request.headers.cookie || ''),
			user = await getUser(cookies, postData, response);
		if (genFunction) return genFunction({ user });
		send(response, 404, _404);
	}));
server.listen(port, () => console.log('server start at http://localhost:' + port));

async function getAndParsePostBody(request) {
	request.setEncoding('utf8');
	const body = await new Promise(resolve => {
		let buff = '';
		request
			.on('data', chunk => buff += chunk)
			.on('end', () => resolve(buff));
	});
	return new URLSearchParams(body);
}

async function getUser(cookies, searchParams, response) {
	let userId = null;
	if (Object.keys(cookies).length > 0) console.log('\t cookies: ', cookies);

	if (cookies.uid) {
		const testUserId = await DB.getUserByCookie(cookies.uid);
		if (testUserId) {
			userId = testUserId;
			console.log(`\t клиент предъявил валидный cookie uid, id = ${userId}`);
		}
	}

	if (searchParams) {
		console.log(`\t form data: ${searchParams}`);
		const
			username = searchParams.get('username'),
			psw = searchParams.get('psw'),
			[id, secret] = await DB.loginUser(username, psw);
		if (username && psw && id && secret) {
			userId = id,
				response.setHeader('Set-Cookie', `uid=${secret}`);
			console.log(`\t login! id = ${userId}`);
		}
		if ('logout' === searchParams.get('action')) {
			console.log(`\t logout! id=${userId}`);
			await DB.delOnlineUser(cookies.uid);
			userId = null;
			response.setHeader('Set-Cookie', `uid=${cookies.uid};Max-Age=0`);
		}
	}
	if (userId) return await DB.getUserData(userId);
	return null;
}

