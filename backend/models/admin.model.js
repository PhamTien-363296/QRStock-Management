import mongoose from "mongoose";


const adminSchema = new mongoose.Schema(
    {
      name: {
        type: String,
        required: true,
      },
      role: {
        type: String,
        required: true,
      },
      password: {
        type: String,
        required: true,
      },
      status: {
        type: String,
        enum: ["active", "inactive"],
        default: "active",
      },
    },
    { timestamps: true }
  );

const Admin = mongoose.model("Admin", adminSchema,"Admin");
export default Admin;