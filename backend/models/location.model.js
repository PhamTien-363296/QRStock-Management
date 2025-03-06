import mongoose from "mongoose";

const locationSchema = new mongoose.Schema({
  warehouse_id: { 
    type: mongoose.Schema.Types.ObjectId,
     ref: "Warehouse",
      required: true
     },
  shelf: { 
    type: String,
     required: true
     },
  bin: { 
    type: String,
     required: true
     },
  max_capacity: { 
    type: Number,
     required: true
     }
}, { timestamps: true });

const Location = mongoose.model("Location", locationSchema,"Location");
export default Location;

