import mongoose from "mongoose";
import Product from "../models/product.model.js";
import Inventory from "../models/inventory.model.js";
import Transaction from "../models/transaction.model.js";
import Log from "../models/log.model.js";


export const addInventory = async (req, res) => {
    try {
        const { quantity, location } = req.body;
        const { product_id } = req.params;
        const user_id = req.user._id; 



        
        if (!mongoose.Types.ObjectId.isValid(product_id)) {
            return res.status(400).json({ success: false, error: "ID sản phẩm không hợp lệ" });
        }
        const productId = new mongoose.Types.ObjectId(product_id);

        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ success: false, error: "Sản phẩm không tồn tại" });
        }

        if (!location) {
            return res.status(400).json({ success: false, error: "Vị trí không được để trống" });
        }

        let inventory = await Inventory.findOne({ product_id: productId, location });

        if (inventory) {
            inventory.quantity += quantity;
        } else {
            inventory = new Inventory({ product_id: productId, quantity, location });
        }
        await inventory.save();

        const transaction = new Transaction({
            product_id: productId,
            transaction_type: "import",
            quantity,
            user_id,
            timestamp: new Date(),
        });
        await transaction.save();

        const log = new Log({
            user_id,
            action: `Added inventory successfully - Product ID: ${productId}, Quantity: ${quantity}, Location: ${location}`,
        });
        await log.save();

        res.status(201).json({
            success: true,
            message: "Thêm hàng vào kho thành công",
            data: { inventory, transaction }
        });
    } catch (error) {
        console.error("Lỗi addInventory:", error.message);
        res.status(500).json({ success: false, error: "Lỗi server" });
    }
};

export const getInventoryInfo = async (req, res) => {
    try {
        const { product_id } = req.params;

      
        if (!mongoose.Types.ObjectId.isValid(product_id)) {
            return res.status(400).json({ success: false, error: "ID sản phẩm không hợp lệ" });
        }
        const productId = new mongoose.Types.ObjectId(product_id);

        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ success: false, error: "Sản phẩm không tồn tại" });
        }

        const inventories = await Inventory.find({ product_id: productId });

        res.status(200).json({
            success: true,
            data: inventories.length > 0 ? inventories : []
        });
    } catch (error) {
        console.error("Lỗi getInventoryInfo:", error.message);
        res.status(500).json({ success: false, error: "Lỗi server" });
    }
};
