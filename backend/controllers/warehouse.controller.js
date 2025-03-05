import Warehouse from "../models/warehouse.model.js";
import { toDataURL } from "qrcode";

export const createWarehouse = async (req, res) => {
    try {
      const { name, location, capacity } = req.body;
  
      if (!name || !location || !capacity) {
        return res.status(400).json({ message: "Vui lòng nhập đầy đủ thông tin." });
      }
  
      
      const newWarehouse = new Warehouse({ name, location, capacity });
  
      
      const qrData = `warehouse:${newWarehouse._id}`;
      const qrCode = await toDataURL(qrData); 
  
     
      newWarehouse.qr_code = qrCode;
  
     
      await newWarehouse.save();
  
      return res.status(201).json({ message: "Tạo kho thành công!", warehouse: newWarehouse });
    } catch (error) {
      console.error("Lỗi khi tạo Warehouse:", error);
      return res.status(500).json({ message: "Lỗi server!" });
    }
  };

export const getAllWarehouses = async (req, res) => {
    try {
      const warehouses = await Warehouse.find();
      return res.status(200).json({ success: true, data: warehouses });
    } catch (error) {
      console.error("Lỗi khi lấy danh sách kho:", error);
      return res.status(500).json({ success: false, message: "Lỗi server!" });
    }
  };
  
  