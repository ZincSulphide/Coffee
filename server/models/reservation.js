const mongoose = require('mongoose');

const reservationSchema = mongoose.Schema({
    username: {
        type: String,
        required: true,
        trim: true,
    },
    Date: {
        type: Date,
        default: Date.now,
        trim: true,
    },
    slot: {
        type: Number,
        required: true,
        trim: true,
    }, // slot needs to be 1-12
    table: {
        type: Number,
        required: true,
        trim: true,
    },
    numberOfPeople: {
        type: Number,
        required: true,
        trim: true,
    },
});

const reservation = mongoose.model("reservation", reservationSchema);
module.exports = {reservation};