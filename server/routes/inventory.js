const express = require("express");
const inventoryRouter = express.Router();
const auth = require("../middleware/auth");
const {inventory} = require("../models/inventory");


// get all inventory:
inventoryRouter.get('/api/inventory/', async(req, res)=>{
    try{
        const allInventory = await inventory.find();
        res.json(allInventory);
    }
    catch(e){
        res.status(500).json({error: e.message});
    }
});

inventoryRouter.post('/api/inventory/add', async(req, res)=>{
    try{
        const newEntry = new inventory(req.body);
        await newEntry.save();
        res.json(newEntry);
    }
    catch(e){
        res.status(500).json({error: e.message});
    }
});

inventoryRouter.post('/api/inventory/update/', async(req, res)=>{
    try{
        const updatedInventory = await inventory.findOneAndUpdate(
            { _id: req.body._id }, // Find by name
            { $set: req.body }, // Update specific fields
            { new: true } // Return the updated document
          );
      
          if (!updatedInventory) {
            return res.status(404).json({ error: 'Inventory not found' });
          }
      
          res.json(updatedInventory);
    }catch (e){
        res.status(500).json({error: e.message});
    }
});

inventoryRouter.delete('/api/inventory/delete/', async(req, res)=>{
    try{
        const ret = await inventory.findOneAndDelete(
            { _id: req.body._id }
          );
        res.status(200).json(ret);
    }catch(e){
        res.status(500).json({error: e.message});
    }
});

module.exports = inventoryRouter;