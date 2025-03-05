import express from "express"
import { addInventory, getInventoryInfo } from "../controllers/inventory.controller.js"
import { protectRoute } from "../middleware/protectRoute.js"


const router = express.Router()

router.post("/add/:product_id",protectRoute,addInventory)
router.get("/get/information/:product_id",getInventoryInfo)


export default router