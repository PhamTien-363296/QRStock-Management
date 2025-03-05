import User from '../models/user.model.js' 
import bcrypt from 'bcryptjs'
import { generateTokenAndSetCookie } from '../lib/utils/generateToken.js';

export const signUp = async (req, res) => {
    try {
        const { username, email, password } = req.body;

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({ error: "Định dạng email không hợp lệ" });
        }

        const user_tonTai = await User.findOne({ username });
        if (user_tonTai) {
            return res.status(400).json({ error: "Tên tài khoản đã được sử dụng" });
        }

        const email_tonTai = await User.findOne({ email });
        if (email_tonTai) {
            return res.status(400).json({ error: "Email này đã được sử dụng" });
        }

        if (password.length <= 6) {
            return res.status(400).json({ error: "Mật khẩu ít nhất phải có 6 ký tự" });
        }

        const salt = await bcrypt.genSalt(10);
        const passwordhash = await bcrypt.hash(password, salt);

        const newUser = new User({
            username,
            email,
            password: passwordhash,
        });

        if (newUser) {
            const token = generateTokenAndSetCookie(newUser._id, res); 
            await newUser.save();

            res.status(201).json({
                _id: newUser._id,
                username: newUser.username,
                email: newUser.email,
                token, 
            });
        } else {
            res.status(400).json({ error: "Thông tin người dùng không hợp lệ" });
        }
    } catch (error) {
        console.log("Lỗi dangKy controller", error.message);
        res.status(500).json({ error: "Lỗi 500" });
    }
};

 
export const login = async (req,res)=>{
    try{
     const {email, password } = req.body
     const user = await User.findOne({email})
     const kiemTra_password = await bcrypt.compare(password, user?.password || "")  
 
     if(!email || !kiemTra_password){
         return res.status(400).json({ error: "Email hoặc mật khẩu không đúng" })
     }

    const token= generateTokenAndSetCookie(user._id,res)
 
     res.status(200).json({
         email: user.email,
         username: user.username,
         _id: user._id,
         token
     })
 
    } catch (error) {
     console.log("Lỗi danhNhap controller",error.message)
     res.status(500).json({ error: "Lỗi 500" })
    }
 }

 
 export const logout = async (req,res)=>{
     try{
         res.cookie("jwt","",{maxAge:0})
         res.status(200).json({ message:"Đăng xuất thành công" })
     } catch (error) {
         console.log("Lỗi dangXuat controller",error.message)
         res.status(500).json({ error: "Lỗi 500"})
     }
 }

 
export const getMe = async(req,res)=>{
    try{
        const user = await User.findById(req.user._id).select("-password")
        res.status(200).json(user)
    }catch(error){
        console.log("Lỗi getMe controller",error.message)
        res.status(500).json({error:"Lỗi 500"})
    }
}