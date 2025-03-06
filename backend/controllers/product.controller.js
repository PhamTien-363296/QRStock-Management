import Product from "../models/product.model.js";
import Inventory from "../models/inventory.model.js";
import Warehouse from "../models/warehouse.model.js";
import Location from "../models/location.model.js";
import { toDataURL } from "qrcode";
import mongoose from "mongoose";


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
  
    
      const qrData = `https://3027-42-114-203-46.ngrok-free.app/product/get/${warehouse_id}/${location_id}`;
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
  
          if (!warehouse_id || !mongoose.Types.ObjectId.isValid(warehouse_id)) {
              return res.status(400).json({ success: false, message: "warehouse_id không hợp lệ." });
          }
  
          if (!location_id || !mongoose.Types.ObjectId.isValid(location_id)) {
              return res.status(400).json({ success: false, message: "location_id không hợp lệ." });
          }
  
          const warehouseObjectId = new mongoose.Types.ObjectId(warehouse_id);
          const locationObjectId = new mongoose.Types.ObjectId(location_id);
  
          const products = await Product.find({ 
              warehouse_id: warehouseObjectId, 
              location_id: locationObjectId 
          });
  
          if (products.length === 0) {
              return res.status(404).json({ success: false, message: "Không có sản phẩm nào." });
          }
  
          const warehouse = await Warehouse.findById(warehouseObjectId).select("name");
          const location = await Location.findById(locationObjectId).select("shelf bin");
  
          if (!warehouse || !location) {
              return res.status(404).json({ success: false, message: "Không tìm thấy kho hoặc vị trí." });
          }
  
          const productDetails = await Promise.all(
              products.map(async (product) => {
                  const inventory = await Inventory.findOne({ product_id: product._id });
  
                  return {
                      _id: product._id,
                      name: product.name,
                      description: product.description,
                      warehouse_name: warehouse.name,
                      location_shelf: location.shelf, 
                      location_bin: location.bin,
                      quantity: inventory ? inventory.quantity : 0,
                      batch: inventory ? inventory.batch : "Không có thông tin",
                      createdAt: inventory ? inventory.createdAt : null,
                      qr_code: product.qr_code,
                  };
              })
          );
  
          return res.status(200).json({ success: true, products: productDetails });
      } catch (error) {
          console.error("Lỗi khi lấy danh sách sản phẩm chi tiết:", error);
          return res.status(500).json({ success: false, message: "Lỗi server!" });
      }
  };
  
