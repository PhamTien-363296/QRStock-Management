import mongoose from "mongoose";

const transactionSchema = new mongoose.Schema(
  {
    product_id: {
      type:  mongoose.Schema.Types.ObjectId, 
      ref: "Product",
      required: true,
    },
    transaction_type: {
      type: String,
      enum: ["import", "export", "transfer", "adjustment"], 
      required: true,
    },
    quantity: {
      type: Number,
      required: true,
      min: 1, 
    },
    user_id: {
      type:  mongoose.Schema.Types.ObjectId, 
      ref: "User",
      required: true,
    },
  },
  { timestamps: true } 
);

const Transaction = mongoose.model("Transaction", transactionSchema,"Transaction");
export default Transaction;
