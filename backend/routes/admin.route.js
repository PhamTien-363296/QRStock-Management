import express from "express"
import { getMeAdmin, loginAdmin } from "../controllers/admin.controller.js"
import { protectAdmin } from "../middleware/protectAdmin.js"
const router = express.Router()


router.post("/login",loginAdmin)
router.get("/getme",protectAdmin,getMeAdmin)

export default router