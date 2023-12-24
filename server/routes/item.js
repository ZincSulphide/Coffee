const express = require("express");
const itemRouter = express.Router();
const auth = require("../middleware/auth");
const {Item} = require("../models/item");

//api/items?category=Essentials
itemRouter.get('/api/items/', auth, async(req, res) => {
    try {
        const items = await Item.find({category: req.query.category});
        res.json(items);
    } catch (e) {
        res.status(500).json({error: e.message})
    }
});

itemRouter.get('/api/items/search/:name', auth, async(req, res) => {
    try {
        const items = await Item.find({
            name:{$regex: req.params.name, $options: "i"},
        });
        res.json(items);
    } catch (e) {
        res.status(500).json({error: e.message})
    }
});

itemRouter.post('/api/rate-product', auth, async (req, res) => {
    try {
        const {id, rating} = req.body;
        let item = await Item.findById(id);

        for(let i = 0; i < item.ratings.length; i++) {
            if(item.ratings[i].userId == req.user) {
                item.ratings.splice(i, 1);
                break;                
            }        
        }
        const ratingSchema = {
            userId: req.user,
            rating,
        }
        item.ratings.push(ratingSchema);
        item = await item.save();
        res.json(item);
        
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

itemRouter.get('/api/deal-of-the-day', auth, async(req, res) => {
    try {
        let items = await Item.find({});

        items = items.sort((a, b) =>{
            let aSum = 0;
            let bSum = 0;
            for(let i = 0; i < a.ratings.length; i++) {
                aSum += a.ratings[i].rating;
            }
            for(let i = 0; i < b.ratings.length; i++) {
                bSum += b.ratings[i].rating;
            }
            return aSum < bSum? 1 : -1;
        });

        res.json(items[0]);

    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

module.exports = itemRouter;
