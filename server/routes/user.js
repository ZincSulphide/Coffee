const express = require("express");
const userRouter = express.Router();
const auth = require('../middleware/auth');
const Order = require('../models/order');
const { Item } = require('../models/item');
const User = require('../models/user')

//Add Item
userRouter.post('/api/add-to-cart', auth, async (req, res) => {
    try {
        
        const { id } = req.body;
        const item = await Item.findById(id);
        let user = await User.findById(req.user);

        //if cart is empty
        if(user.cart.length == 0) {
            user.cart.push({ item, quantity: 1 });
        } else {
            let isProductFound = false;
            for(let i = 0; i < user.cart.length; i++) {
                if(user.cart[i].item._id.equals(item._id)) {
                    isProductFound = true;
                }
            }
            if (isProductFound) {
                let item1 = user.cart.find((item2) => //item1 = producttt, item2 = productt 8:19:42
                    item2.item._id.equals(item._id)
                );
                item1.quantity += 1;
                // console.log("incremented by 1");
            } else {
                user.cart.push({ item, quantity: 1 });
            }
        }
            user = await user.save();
            res.json(user);
            // console.log("hello this is being called " + res);
        
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});
userRouter.delete('/api/remove-from-cart/:id', auth, async (req, res) => {
    try {
        
        const { id } = req.params;
        const item = await Item.findById(id);
        let user = await User.findById(req.user);

        for(let i = 0; i < user.cart.length; i++) {
            if(user.cart[i].item._id.equals(item._id)) {
                if(user.cart[i].quantity == 1) {
                    user.cart.splice(i, 1);
                } else {
                    user.cart[i].quantity -= 1;
                }
            }
        }        
        user = await user.save();
        res.json(user);
        // console.log("hello this is being called " + res);
        
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

//save user address
userRouter.post('/api/save-user-address', auth, async(req, res) => {
    try {
        const { address } = req.body;
        let user = await User.findById(req.user);
        user.address = address;
        user = await user.save();
        res.json(user);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

//ordering item
userRouter.post('/api/order', auth, async(req, res) => {
    try {
        const { cart, totalPrice, address } = req.body;
        let items = [];

        for (let i = 0; i < cart.length; i++) {
            let item = await Item.findById(cart[i].item._id);
            // if (item.quantity >= cart[i].quantity) {
            //     item.quantity -= cart[i].quantity;
            //*subtract ordered items from available.
            //*ei case e applicable na but need to smhow find a way to cut it from inventory 
            items.push({item, quantity:cart[i].quantity});
            await item.save();
            // } else {
            //     return res.status(400).json({msg: `${item.name} cannot be ordered now! `});
            // }//*if required ingredients are not in inventory
            //TODO: find a way to apply inventory to this part.   
        }
        let user = await User.findById(req.user);
        user.cart = [];
        user = await user.save();

        let order = new Order ({
            items,
            totalPrice,
            address,
            userId : req.user,
            orderedAt: new Date().getTime(),
        });
        order = await order.save();

        res.json(order);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

userRouter.get("/api/orders/me", auth, async (req, res) => {
    try {
      const orders = await Order.find({ userId: req.user });
      res.json(orders);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });



module.exports = userRouter;
