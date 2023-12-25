const mongoose = require('mongoose');

const inventorySchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    entryDate: {
        type: Date,
        default: Date.now,
        trim: true,
    },
    expirationTimer_days: {
        type: Number,
        default: 1,
    },
    amount: {
        type: Number,
        required: true,
    },
});

const inventory = mongoose.model("inventory", inventorySchema);
module.exports = {inventory};