import mongoose from "mongoose";

const logSchema = new mongoose.Schema(
  {
    user_id: {
      type:  mongoose.Schema.Types.ObjectId, 
      ref: "User",
      required: true,
    },
    action: {
      type: String,
      required: true,
    },
    timestamp: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true } 
);

const Log = mongoose.model("Log", logSchema,"Log");
export default Log;
