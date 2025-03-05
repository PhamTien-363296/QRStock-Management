import mongoose from "mongoose";

const warehouseSchema = new mongoose.Schema({
    name: { 
        type: String,
         required: true 
        },
    location: { 
         type: String,
         required: true 
        },
    capacity: { 
        type: Number,
         required: true
         },
    qr_code: { 
        type: String
     }
  }, { timestamps: true })

const Warehouse = mongoose.model("Warehouse", warehouseSchema,"Warehouse");

export default Warehouse;
