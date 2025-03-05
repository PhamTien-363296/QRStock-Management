import mongoose from "mongoose";

const inventorySchema = new mongoose.Schema({
    product_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "Product", 
        required: true 
    },
    quantity: { 
        type: Number, 
        required: true, 
        min: 0 
    },
    location: {
        type: String, 
        required: true 
    },
    createdAt: { 
        type: Date, 
        default: Date.now 
    }
});

const Inventory = mongoose.model("Inventory", inventorySchema, "Inventory");
export default Inventory;
