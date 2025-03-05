import mongoose from "mongoose";

const inventorySchema = new mongoose.Schema({
  product_id: { 
    type: mongoose.Schema.Types.ObjectId,
     ref: "Product",
      required: true 
    },
  warehouse_id: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: "Warehouse", 
    required: true },
  location_id: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: "Location", 
    required: true },
  quantity: { 
    type: Number, 
    required: true },
  batch: { 
    type: String 
    },
  expiry_date: { 
    type: Date 
    },
  qr_code: { 
    type: String 
    }
}, { timestamps: true });

const Inventory = mongoose.model("Inventory", inventorySchema,"Inventory");
export default Inventory;
