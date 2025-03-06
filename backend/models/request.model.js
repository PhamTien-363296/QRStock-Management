import mongoose from "mongoose";


const requestSchema = new mongoose.Schema(
  {
    warehouse_id: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Warehouse",
    },
    product_id: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Product",
    },
    quantity: {
      type: Number,
      required: true,
    },
    reason: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

const Request = mongoose.model("Request", requestSchema,"Request");
export default Request;