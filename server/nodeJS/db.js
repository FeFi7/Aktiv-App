var mysql = require('mysql2');

const pool = mysql.createPool({
    host: 'h2931685.stratoserver.net',
    user: 'nodeUser',
    password: 'epNpU5bT6fB8vn6A',
    database: 'aktivapp',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
    });

pool.on('connection', function (connection) {
    console.log(pool._allConnections.length + " aktuell offener connections");
});

const  getConnection = () => pool;


module.exports = {
    getConnection: getConnection
}

