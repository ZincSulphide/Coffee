const express = require("express");
const app = express();
const mysql = require("mysql2");
const cors = require('cors');
app.use(cors());
app.use(express.json());
require("dotenv").config();
const db = require('./db');



app.use("/login", require("./routes/login.js"));
app.use("/signup", require("./routes/signup.js"));
app.use("/forgetpassword", require("./routes/forgetpassword.js"));
app.use("/changepassword", require("./routes/changepassword.js"));
app.use("/user", require("./routes/user.js"));
app.use("/item", require("./routes/item.js"));
app.use("/booking", require("./routes/reservation.js"));


// For /login
app.post("/login", (req, res) => {
    const username = req.body.username;
    const password = req.body.password;

    db.query(
        "SELECT * FROM CUSTOMER WHERE USERNAME = ? AND PASSWORD = ?",
        [username, password],
        (err, result) => {
            if (err) {
                console.log(err);
            } else {
                console.log("Login Successful");
                res.send(result);
            }
        }
    );
});

// For /signup
app.post("/signup", (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    const customerType = req.body.customerType;

    db.query(
        "INSERT INTO CUSTOMER (USERNAME, PASSWORD, CUSTOMER_TYPE) VALUES (?, ?, ?)",
        [username, password, customerType],
        (err, result) => {
            if (err) {
                console.log(err);
            } else {
                console.log("Signup Successful");
                res.send(result);
            }
        }
    );
});

// For /forgetpassword
app.post("/forgetpassword", (req, res) => {
    
    const username = req.body.username;
    const encrypted_password = req.body.newPassword;
    
    db.query(
        "UPDATE users SET password = ? WHERE username = ?",
        [encrypted_password,username],
        (err,result) =>{
            //console.log(result[0]);
            if(err){
                console.log("why");
                res.send({message:err});
            }
            else{
                res.send("password reset complete");
            }
        }
    );
    res.send("Password recovery logic goes here");
});

// For /changepassword
app.post("/changepassword", (req, res) => {
    const username = req.body.username;
    const newPassword = req.body.newPassword;

    db.query(
        "UPDATE CUSTOMER SET PASSWORD = ? WHERE USERNAME = ?",
        [newPassword, username],
        (err, result) => {
            if (err) {
                console.log(err);
            } else {
                console.log("Password Changed Successfully");
                res.send(result);
            }
        }
    );
});


router.post("/", (req,res)=>{
    const username = req.body.username;
    const password = "31121";

    var mod = 1e9 + 7;
    var base = 11;
    var cur = 1, hash = 0;
    for (let i = 0; i < password.length; i++) {
        hash = (hash + cur * password.charCodeAt(i));
        //console.log(hash);
        cur = (cur * base) % mod;
    }
    const hashh=hash
    
    tomail=username;
    db.query(
        "UPDATE users SET password = ? WHERE username = ?",
        [hashh,username],
        (err,result) =>{
            //console.log(result[0]);
            if(err){
                console.log("why");
                res.send({message:err});
            }
            else{
                res.send("password sent");

                const sendMail = async (msg) => {
                    try{
                        await sgMail.send(msg);
                        console.log("Message sent succesfully!");
                    }
                    catch(error){
                        console.log(error);
                        if(error.response){
                            console.error(error.response.body);
                        }
                    }
                };
                sendMail({
                    to:username,
                    from:"temporary171842@gmail.com",
                    subject: "COFFEE_MAKERS",
                    text:"Useremail: " + username + "    password: " + password,
                });
            }
        }
    );

});


function getTotalAmountByItem() {
    const query = `
      SELECT
        t.ITEM_PURCHASED,
        m.PRICE,
        COUNT(t.TRANSACTION_ID) AS purchase_count,
        SUM(t.AMOUNT) AS total_amount
      FROM
        TRANSACTIONS t
      LEFT JOIN
        MENU m ON t.ITEM_PURCHASED = m.NAME
      LEFT JOIN
        SPECIALS s ON t.ITEM_PURCHASED = s.NAME
      GROUP BY
        t.ITEM_PURCHASED
      ORDER BY
        total_amount DESC
      LIMIT 1;
    `;
  
    db.query(query, (error, results) => {
      if (error) {
        console.error(error);
      } else {
        console.log(results);
      }
    });
  }


  app.post("/admin", (req, res) => {
    const { USERNAME, PASSWORD, CONTACT_INFO } = req.body;
    const query = "INSERT INTO ADMIN (USERNAME, PASSWORD, CONTACT_INFO) VALUES (?, ?, ?)";
    db.query(query, [USERNAME, PASSWORD, CONTACT_INFO], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error inserting into ADMIN table");
        } else {
            console.log("Inserted into ADMIN table");
            res.send(result);
        }
    });
});


app.post("/customer", (req, res) => {
    const { CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_TYPE } = req.body;
    const query = "INSERT INTO CUSTOMER (CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_TYPE) VALUES (?, ?, ?, ?)";
    db.query(query, [CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_TYPE], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error inserting into CUSTOMER table");
        } else {
            console.log("Inserted into CUSTOMER table");
            res.send(result);
        }
    });
});


app.post("/reservation", (req, res) => {
    const { DATE_TIME, PERSON_COUNT, CUSTOMER_ID } = req.body;
    const query = "INSERT INTO RESERVATION (DATE_TIME, PERSON_COUNT, CUSTOMER_ID) VALUES (?, ?, ?)";
    db.query(query, [DATE_TIME, PERSON_COUNT, CUSTOMER_ID], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error inserting into RESERVATION table");
        } else {
            console.log("Inserted into RESERVATION table");
            res.send(result);
        }
    });
});


app.post("/menu", (req, res) => {
    const { NAME, DESCRIPTION, PRICE, PICTURE } = req.body;
    const query = "INSERT INTO MENU (NAME, DESCRIPTION, PRICE, PICTURE) VALUES (?, ?, ?, ?)";
    db.query(query, [NAME, DESCRIPTION, PRICE, PICTURE], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error inserting into MENU table");
        } else {
            console.log("Inserted into MENU table");
            res.send(result);
        }
    });
});


app.post("/transactions", (req, res) => {
    const { TRANSACTION_ID, AMOUNT, ITEM_PURCHASED, CUSTOMER_ID, STATUS } = req.body;
    const query = "INSERT INTO TRANSACTIONS (TRANSACTION_ID, AMOUNT, ITEM_PURCHASED, CUSTOMER_ID, STATUS) VALUES (?, ?, ?, ?, ?)";
    db.query(query, [TRANSACTION_ID, AMOUNT, ITEM_PURCHASED, CUSTOMER_ID, STATUS], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error inserting into TRANSACTIONS table");
        } else {
            console.log("Inserted into TRANSACTIONS table");
            res.send(result);
        }
    });
});


app.post("/specials", (req, res) => {
    const { DAY, NAME } = req.body;
    const query = "INSERT INTO SPECIALS (DAY, NAME) VALUES (?, ?)";
    db.query(query, [DAY, NAME], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error inserting into SPECIALS table");
        } else {
            console.log("Inserted into SPECIALS table");
            res.send(result);
        }
    });
});

app.post("/inventory", (req, res) => {
    const { NAME, QUANTITY, DATE_ADDED, LIFE_TIME } = req.body;
    const query = "INSERT INTO INVENTORY (NAME, QUANTITY, DATE_ADDED, LIFE_TIME) VALUES (?, ?, ?, ?)";
    db.query(query, [NAME, QUANTITY, DATE_ADDED, LIFE_TIME], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error inserting into INVENTORY table");
        } else {
            console.log("Inserted into INVENTORY table");
            res.send(result);
        }
    });
});

  
// Call the function to obtain the total amount spent on the most purchased item
router.get("/calculate_total_profit", (req,res)=>{
    try {
        res.send(getTotalAmountByItem());   
    } catch (error) {
        res.send(error.message);
    }
        
});

router.get("/inventory", (req, res) => {
    const query = "SELECT * FROM INVENTORY ORDER BY QUANTITY DESC";
    db.query(query, (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error fetching inventory items");
        } else {
            console.log("Fetched inventory items");
            res.send(result);
        }
    });
});

router.get("/menu", (req, res) => {
    const query = "SELECT * FROM MENU ORDER BY NAME ASC";
    db.query(query, (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send("Error fetching menu items");
        } else {
            console.log("Fetched menu items");
            res.send(result);
        }
    });
});


module.exports = router;

app.listen(3001,()=>{
    console.log("server is running ");
})