import Admin from "../models/admin.model.js";
import bcrypt from "bcryptjs";
import { generateTokenAM } from "../lib/utils/generateTokenAM.js";
export const loginAdmin = async (req, res) => {
    try {
      const { name, password } = req.body;
  
      const admin = await Admin.findOne({ name }).lean(); 
  
      if (!admin) {
        return res.status(400).json({ error: "Tên đăng nhập hoặc mật khẩu không đúng" });
      }
  
      const kiemTra_password = await bcrypt.compare(password, admin.password);
      if (!kiemTra_password) {
        return res.status(400).json({ error: "Tên đăng nhập hoặc mật khẩu không đúng" });
      }
  
      if (admin.status !== "active") {
        return res.status(403).json({ error: "Tài khoản của bạn đã bị vô hiệu hóa" });
      }
  
    
  
      generateTokenAM(admin._id, admin.role, res);
  
      res.status(200).json({
        name: admin.name,
        role: admin.role,
        _id: admin._id,
      });
  
    } catch (error) {
      console.log("Lỗi loginAdmin:", error);
      res.status(500).json({ error: "Lỗi 500" });
    }
  };
  

export const getMeAdmin = async (req, res) => {
    try {

      const admin = await Admin.findById(req.admin._id).select("-password");
  
      if (!admin) {
        return res.status(404).json({ error: "Không tìm thấy admin" });
      }
  
      res.status(200).json(admin);
    } catch (error) {
      console.log("Lỗi getMeAdmin:", error.message);
      res.status(500).json({ error: "Lỗi 500" });
    }
  };
  