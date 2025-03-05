import Product from "../models/product.model.js";
import { toDataURL } from "qrcode";


export const createProduct = async (req, res) => {
    try {
      const { name, description } = req.body;
      const { warehouse_id, location_id } = req.params; 
  
   
      if (!warehouse_id) {
        return res.status(400).json({ message: "Thiếu warehouse_id." });
      }

      if (!location_id) {
        return res.status(400).json({ message: "Thiếu location_id." });
      }
  
      if (!name || !description) {
        return res.status(400).json({ message: "Vui lòng nhập đầy đủ thông tin." });
      }
  
    
      const qrData = JSON.stringify({ warehouse_id, location_id, name , description });
  
 
      const qrCode = await toDataURL(qrData);
  
 
      const newProduct = new Product({
        warehouse_id,
        location_id,
        name,
        description,
        qr_code: qrCode,
      });
  
    
      await newProduct.save();
  
      return res.status(201).json({ success: true, message: "Thêm product thành công!", product: newProduct });
    } catch (error) {
      console.error("Lỗi khi thêm product:", error);
      return res.status(500).json({ success: false, message: "Lỗi server!" });
    }
  };


  export const getProductByWarehouseAndLocationId = async (req, res) => {
    try {
        const { warehouse_id, location_id } = req.params;

        if (!warehouse_id) {
            return res.status(400).json({ success: false, message: "Thiếu warehouse_id." });
        }

        if (!location_id) {
            return res.status(400).json({ success: false, message: "Thiếu location_id." });
        }

        const products = await Product.find({ warehouse_id, location_id });

        return res.status(200).json({
            success: true,
            products,
        });
    } catch (error) {
        console.error("Lỗi khi lấy danh sách sản phẩm:", error);
        return res.status(500).json({ success: false, message: "Lỗi server!" });
    }
};
