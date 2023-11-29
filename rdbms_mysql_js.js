const { Module } = require('module');
const mysql = require('mysql2');

const db= mysql.createConnection({
    host:   'localhost',
    user: "root",
    password: "1234",
    database: "loginsystem"
    // insecureAuth : true
});

db.connect((error) => {
    if (error) {
      console.error('Error connecting to the database:', error);
      return;
    }
    console.log('Connected to the database');
  });
  
  module.exports = db;

// Create a MySQL pool
const pool = mysql.createPool(db);

// Schedule the task to run every minute


setInterval(cron.schedule('* * * * *', async () => {
    try {
      // Get a connection from the pool
      const connection = await pool.promise().getConnection();
  
      // Execute the stored procedure
      await connection.execute('CALL REMOVE_EXPIRED_ITEMS()');
  
      // Release the connection back to the pool
      connection.release();
    } catch (error) {
      console.error('Error:', error);
    }
  }), 60 * 1000); // calls every 1 min

Module.exports = db;