import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
    name: { 
        type: String,
        required: true,
        unique: true 
    },
    qr_code: { 
        type: String,
        unique: true 
    },
    description: {
        type: String,
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
});

const Product = mongoose.model("Product", productSchema, "Product");

export default Product;
