const mongoose = require('mongoose');
const ratingSchema = require('./rating');

const itemSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
        trim: true,
    },
    images: [{
        type: String,
        required: true,
    },],
    price: {
        type: Number,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    ratings: [ratingSchema],
});

const Item = mongoose.model("Item", itemSchema);
module.exports = {Item, itemSchema};