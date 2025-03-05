import Location from "../models/location.model.js";
import Warehouse from "../models/warehouse.model.js";
import { toDataURL } from "qrcode";

export const createLocation = async (req, res) => {
    try {
      const { shelf, bin, max_capacity } = req.body;
      const { warehouse_id } = req.params; 
  
   
      if (!warehouse_id) {
        return res.status(400).json({ message: "Thiếu warehouse_id." });
      }
  
      if (!shelf || !bin || !max_capacity) {
        return res.status(400).json({ message: "Vui lòng nhập đầy đủ thông tin." });
      }
  
    
      const qrData = JSON.stringify({ warehouse_id, shelf, bin, max_capacity });
  
 
      const qrCode = await toDataURL(qrData);
  
 
      const newLocation = new Location({
        warehouse_id,
        shelf,
        bin,
        max_capacity,
        qr_code: qrCode,
      });
  
    
      await newLocation.save();
  
      return res.status(201).json({ success: true, message: "Thêm location thành công!", location: newLocation });
    } catch (error) {
      console.error("Lỗi khi thêm location:", error);
      return res.status(500).json({ success: false, message: "Lỗi server!" });
    }
  };


  export const getLocationByWareHouseId = async (req, res) => {
    try {
      const { warehouse_id } = req.params; 
  
      if (!warehouse_id) {
        return res.status(400).json({ success: false, message: "Thiếu warehouse_id." });
      }
  
      
      const locations = await Location.find({ warehouse_id });
  
      return res.status(200).json({ success: true, data: locations });
    } catch (error) {
      console.error("Lỗi khi lấy danh sách location:", error);
      return res.status(500).json({ success: false, message: "Lỗi server!" });
    }
  };
  
  
