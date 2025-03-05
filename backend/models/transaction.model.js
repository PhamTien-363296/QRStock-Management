import mongoose from "mongoose";

const transactionSchema = new mongoose.Schema({
  product_id: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: "Product", 
    required: true 
  },
  warehouse_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "Warehouse", 
    required: true 
  },
  location_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "Location", 
    required: true 
  },
  transaction_type: { 
    type: String, 
    enum: ["import", "export"], 
    required: true 
  },
  quantity: { 
    type: Number, 
    required: true 
  },
  user_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "User", 
    required: true },
  qr_code: {
    type: String 
  },
  date: { 
    type: Date, 
    default: Date.now 
  }
}, { timestamps: true });


const Transaction = mongoose.model("Transaction", transactionSchema,"Transaction");

export default Transaction;
