const mongoose = require ('mongoose');
const orderSchema = mongoose.Schema({
    items: [
        {
            item: itemSchema,
            quantity: {
                type: Number,
                required: true,
            },
        },
    ],
    totalPrice : {
        type: Number,
        required: true,
    },
    address: {
        type: String,
        required: true,
    },
    userId: {
        required: true,
        type: String,
    },
    orderedAt: {
        type: Number,
        required: true,
    },
    status: {
        type: Number,
        default: 0,//0 = pending/placed, 1 = completed, 3 = delivered
    }
});

const Order = mongoose.model('Order', orderSchema);
module.exports = Order;