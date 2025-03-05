import Product from "../models/product.model.js";
import { toDataURL } from "qrcode";


// export const createProduct = async (req, res) => {
//     try {
//         const { name, description } = req.body; 
//         const user_id = req.user._id; 

      

//         const existingProduct = await Product.findOne({ name });
//         if (existingProduct) {
//             return res.status(400).json({ success: false, message: "Product already exists" });
//         }


//         const qrCodeData = `Product: ${name}`;
//         const qrCodeImage = await QRCode.toDataURL(qrCodeData);

 
//         const newProduct = new Product({
//             name,
//             qr_code: qrCodeImage,
//             description,
//         });

//         await newProduct.save();

     
//         const log = new Log({
//             user_id,
//             action: `Created product: ${name} (ID: ${newProduct._id})`, 
//         });

//         await log.save();

//         return res.status(201).json({
//             success: true,
//             message: "Product created successfully",
//             product: newProduct,
//         });
//     } catch (error) {
//         console.error("Error creating product:", error);
//         return res.status(500).json({ success: false, message: "Internal server error" });
//     }
// };



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