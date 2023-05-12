import { createConnection } from 'mysql2/promise';


const
	salt = 'mySuper%SecretSalt!*&^%$#', // TODO move to .env-file 
	connection = await createConnection('mysql://user:111@localhost/formdb'),

	testUserQ = await connection.prepare(`SELECT id 
    FROM users   
    WHERE login = ? AND psw =  PASSWORD(CONCAT('${salt}',?))`),

	getUserDataQ = await connection.prepare(`SELECT id, login, realname FROM users WHERE id = ?`),

	newSessionQ = await connection.prepare(`INSERT INTO sessions (userId,secret) values(?,?)`),

	getSessionUserIdQ = await connection.prepare(`SELECT users.id 
    FROM sessions JOIN users ON users.id = sessions.userId 
    WHERE secret = ? `),
	deleteSessionQ = await connection.prepare('delete from sessions where secret=?'),
	getAllPostsQ = await connection.prepare('SELECT posts.title, posts.body, posts.time, users.realname  from posts JOIN users ON users.id = posts.userId'),
	DB = {
		async delOnlineUser(uid) { await deleteSessionQ.execute([uid]); },

		async getUserByCookie(secret) {
			const [users] = await getSessionUserIdQ.execute([secret]);
			return users?.[0]?.id;
		},

		async getUserData(id) {
			const [users] = await getUserDataQ.execute([id]);
			return users?.[0];

		},

		async loginUser(login, pass) {
			const [users] = await testUserQ.execute([login, pass]);
			if (login && pass & 1 === users.length) {
				const
					[user] = users,
					secret = this.newUID();
				await newSessionQ.execute([user.id, secret]);
				return [user.id, secret];
			}
			return [null, null];
		},

		newUID() { return '' + Math.random(); }
	};

export default DB;
