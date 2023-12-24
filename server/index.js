//IMPORTS FROM PACKAGES
const express = require('express'); //basically importing package
const mongoose = require('mongoose');

//imports from files

const adminRouter = require('./routes/admin');
const authRouter = require('./routes/auth');
const itemRouter = require('./routes/item');
const userRouter = require('./routes/user');
const reservationRouter = require('./routes/reservation');
const inventoryRouter = require('./routes/inventory');

//initializations
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://zunairasultan:asdfg@cluster0.twa4ocv.mongodb.net/?retryWrites=true&w=majority";

//middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(itemRouter);
app.use(userRouter);
app.use(reservationRouter);
app.use(inventoryRouter);

//connections
mongoose.connect(DB).then(() => {
    console.log("Connection Successful");
}).catch((e) => {
    console.log(e);
});

app.listen(PORT,  "0.0.0.0", () => {
    console.log(`Connected at port  ${PORT}`);
});//localhost won't work on android

