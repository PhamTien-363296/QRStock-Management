import mongoose from "mongoose";
import Product from "../models/product.model.js";
import Inventory from "../models/inventory.model.js";
import Transaction from "../models/transaction.model.js";
import Log from "../models/log.model.js";
import Warehouse from "../models/warehouse.model.js";
import Location from "../models/location.model.js";
import { toDataURL } from "qrcode";
import { v4 as uuidv4 } from 'uuid';


export const addInventory = async (req, res) => {
    try {
        const { quantity, batch, expiry_date } = req.body;
        const { product_id, warehouse_id, location_id } = req.params; 
        const user_id = req.user._id; 

        if (!mongoose.Types.ObjectId.isValid(product_id) ||
            !mongoose.Types.ObjectId.isValid(warehouse_id) ||
            !mongoose.Types.ObjectId.isValid(location_id)) {
            return res.status(400).json({ success: false, error: "ID không hợp lệ" });
        }

        const productId = new mongoose.Types.ObjectId(product_id);
        const warehouseId = new mongoose.Types.ObjectId(warehouse_id);
        const locationId = new mongoose.Types.ObjectId(location_id);

        const product = await Product.findById(productId);
        if (!product) return res.status(404).json({ success: false, error: "Sản phẩm không tồn tại" });

        const warehouse = await Warehouse.findById(warehouseId);
        if (!warehouse) return res.status(404).json({ success: false, error: "Kho không tồn tại" });

        const location = await Location.findById(locationId);
        if (!location) return res.status(404).json({ success: false, error: "Vị trí không tồn tại" });

        if (!quantity || quantity <= 0) {
            return res.status(400).json({ success: false, error: "Số lượng không hợp lệ" });
        }

        
        if (quantity > location.max_capacity) {
            return res.status(400).json({ success: false, error: "Số lượng vượt quá dung lượng của vị trí" });
        }

        location.max_capacity -= quantity; 
        await location.save();

        
        const qrData = `https://qrfrontend.vercel.app/product/g/${warehouse_id}/${location_id}/${product_id}?timestamp=${new Date().getTime()}&unique_id=${uuidv4()}`;
        const qrCode = await toDataURL(qrData);



        let inventory = await Inventory.findOne({ product_id: productId, warehouse_id: warehouseId, location_id: locationId });

        if (inventory) {
            inventory.quantity += quantity;
        } else {
            inventory = new Inventory({ 
                product_id: productId, 
                warehouse_id: warehouseId, 
                location_id: locationId, 
                quantity, 
                batch, 
                expiry_date ,
                qr_code: qrCode,
            });
        }
        await inventory.save();

        product.qr_code = qrCode;
        await product.save();

        const transaction = new Transaction({
            product_id: productId,
            warehouse_id: warehouseId,
            location_id: locationId,
            transaction_type: "import",
            quantity,
            user_id,
            date: new Date(), 
        });
        await transaction.save();

        const log = new Log({
            user_id,
            action: `Thêm hàng vào kho - Sản phẩm: ${productId}, Số lượng: ${quantity}`,
            timestamp: new Date(),
            location: `${warehouse.name} - ${location.shelf}-${location.bin}`, 
        });
        await log.save();

        res.status(201).json({
            success: true,
            message: "Thêm hàng vào kho thành công",
            data: { inventory, transaction, log }
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
