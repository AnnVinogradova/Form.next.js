import { URL } from 'node:url';
import { compileFile } from 'pug';

import pages from './pug/pages.mjs';


const
	PUGPATH = './pug/',
	paths = new Map(pages.map(page => [page.href, compileFile(PUGPATH + page.pug)])),
	posts = await ((await fetch('https://jsonplaceholder.typicode.com/posts')).json());

export const _404 = compileFile(PUGPATH + '404.pug')();

export default function getGenFunction(request) {
	const
		urlObject = new URL(request.url, `http://${request.headers.host}`),
		url = urlObject.pathname,
		page = pages.find(({ href }) => href === url);

	if (paths.has(url)) return (obj = {}) => paths.get(url)({ pages, page, posts, ...obj });
	return null;
}