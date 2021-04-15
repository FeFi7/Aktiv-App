var mysql = require('mysql2');

const config = require('config')
const dbConfig = config.get('Customer.dbConfig');

const pool = mysql.createPool({
    host: dbConfig.host,
    user: dbConfig.user,
    password: dbConfig.password,
    database: dbConfig.database,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    port: 3306
    });

pool.on('connection', function (connection) {
    console.log(pool._allConnections.length + " aktuell offener connections");
});

const getConnection = () => pool.promise();

module.exports = {
    getConnection: getConnection
}

