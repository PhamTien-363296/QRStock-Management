import Product from "../models/product.model.js";
import QRCode from 'qrcode'

export const createProduct = async (req, res) => {
    try {
        const { name, description } = req.body;

        
        const existingProduct = await Product.findOne({ name });
        if (existingProduct) {
            return res.status(400).json({ success: false, message: "Product already exists" });
        }

       
        const qrCodeData = `Product: ${name}`;
        const qrCodeImage = await QRCode.toDataURL(qrCodeData);

       
        const newProduct = new Product({
            name,
            qr_code: qrCodeImage, 
            description,
        });

        await newProduct.save();

        return res.status(201).json({
            success: true,
            message: "Product created successfully",
            product: newProduct
        });
    } catch (error) {
        console.error("Error creating product:", error);
        return res.status(500).json({ success: false, message: "Internal server error" });
    }
};

export const getAllProducts = async (req, res) => {
    try {
        const products = await Product.find({}, 'name description qr_code'); 

        return res.status(200).json({
            success: true,
            products: products
        });
    } catch (error) {
        console.error("Error fetching products:", error);
        return res.status(500).json({ success: false, message: "Internal server error" });
    }
};