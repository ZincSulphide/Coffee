const express = require('express');
const adminRouter = express.Router();
const admin = require('../middleware/admin');
const {Item} = require('../models/item');
const Order = require('../models/order');
// const {PromiseProvider} = require("mongoose");

//Add Item
adminRouter.post('/admin/add-item', admin, async (req, res) => {
    try {
        const {name, description, images, price, category} = req.body;
        let item = new Item({
            name,
            description,
            images,
            price,
            category,
        });
        item = await item.save();
        res.json(item);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

//Get Items
adminRouter.get('/admin/get-items', admin, async(req, res) => {
    try {
        const items = await Item.find({});
        res.json(items);
    } catch (e) {
        req.status(500).json({error: e.message})
    }
});

//Delete item
adminRouter.post('/admin/delete-item', admin, async(req, res) => {
    try {
        const {id} = req.body;
        let item = await Item.findByIdAndDelete(id);
        res.json(item);
    } catch (e) {
        res.status(500).json({error: e.message})
    }
})

//get orders
adminRouter.get('/admin/get-orders', admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        res.json(orders);

    } catch (error) {
        res.status(500).json({error: error.message});
    }
})

adminRouter.post('/admin/change-order-status', admin, async(req, res) => {
    try {
        const {id, status} = req.body;
        let order = await Order.findById(id);
        order.status = status;
        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({error: e.message})
    }
})

adminRouter.get('/admin/analytics', admin, async(req, res) => {
    try {
        const orders = await Order.find({});
        let totalEarnings = 0;
        for (let i = 0; i < orders.length; i++) {
            for (let j = 0 ; j < orders[i].items.length; j++) {
                totalEarnings += orders[i].items[j].quantity * orders[i].items[j].price;
            }
        }
        //fetch category wise orders
        let coffeeEarnings = await fetchCategoryWiseItem('Coffee');
        let teaEarnings = await fetchCategoryWiseItem('Tea');
        let sandwichesEarnings = await fetchCategoryWiseItem('Sandwiches');
        let dessertsEarning = await fetchCategoryWiseItem('Desserts');
        let breakfastEarning = await fetchCategoryWiseItem('Breakfast');

        let earnings = {
            totalEarnings,
            coffeeEarnings,
            teaEarnings,
            sandwichesEarnings,
            dessertsEarning,
            breakfastEarning,            
        };

        res.json(earnings);
        
    } catch (error) {
        res.status(500).json({error: error.message});
    }
})

async function fetchCategoryWiseItem(category) {
    let earnings = 0;
    let categoryOrders = await Order.find({
        'items.item.category': category,
    })
    for (let i = 0; i < categoryOrders.length; i++) {
        for (let j = 0 ; j < categoryOrders[i].items.length; j++) {
            earnings += 
            categoryOrders[i].items[j].quantity * categoryOrders[i].items[j].price;
        }
    }
    return earnings;
}

module.exports = adminRouter;

