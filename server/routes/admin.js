const express = require('express');
const adminRouter = express.Router();
const admin = require('../middleware/admin');
const {Item} = require('../models/item');
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

module.exports = adminRouter;

