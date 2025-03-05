import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
    name: 
    { 
        type: String,
        required: true,
        unique: true 
    },
    qr_code: 
    { 
        type: String,
        required: true, 
        unique: true 
    },
    description: {
        type: String,
    },
});

const Product = mongoose.model("Product", productSchema,"Product");

export default Product;
