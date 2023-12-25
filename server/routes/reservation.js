const express = require("express");
const reservationRouter = express.Router();
const auth = require("../middleware/auth");
const {reservation} = require("../models/reservation");


// get all reservation:
reservationRouter.get('/api/reservation/', async(req, res)=>{
    try{
        const allReservations = await reservation.find();
        res.json(allReservations);
    }
    catch(e){
        res.status(500).json({error: e.message});
    }
});

reservationRouter.post('/api/reservation/add', async(req, res)=>{
    try{
        const newEntry = new reservation(req.body);
        await newEntry.save();
        res.json(newEntry);
    }
    catch(e){
        res.status(500).json({error: e.message});
    }
});

reservationRouter.post('/api/reservation/update/', async(req, res)=>{
    try{
        const updatedReservation = await reservation.findOneAndUpdate(
            { _id: req.body._id }, // Find by name
            { $set: req.body }, // Update specific fields
            { new: true } // Return the updated document
          );
      
          if (!updatedReservation) {
            return res.status(404).json({ error: 'Reservation not found' });
          }
      
          res.json(updatedReservation);
    }catch (e){
        res.status(500).json({error: e.message});
    }
});

reservationRouter.delete('/api/reservation/delete/', async(req, res)=>{
    try{
        const ret = await reservation.findOneAndDelete(
            { _id: req.body._id }
          );
        res.status(200).json(ret);
    }catch(e){
        res.status(500).json({error: e.message});
    }
});

module.exports = reservationRouter;