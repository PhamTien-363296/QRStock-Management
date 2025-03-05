import User from '../models/user.model.js'
import jwt from "jsonwebtoken"

export const protectRoute = async (req,res,next)=>{
    try{
        let token = req.cookies.jwt || req.headers.authorization?.split(" ")[1];
        if(!token){
            return res.status(401).json({error:"Bạn cần đăng nhập trước"})
        }
        const decoded = jwt.verify(token,process.env.JWT_SECRET)

        if(!decoded){
            return res.status(401).json({error:"không xác thực : token không hợp lệ"})
        }
        const user = await User.findById(decoded.user_id).select("-password")
        if(!user){
            return res.status(401).json({error:"Không tìm thấy người dùng"})
        }
        req.user = user
        next()
    } catch(error){
        console.log("Lỗi protectRoute ",error.message)
        return res.status(500).json({error:" Lỗi 500" })
    }
}


