import express from "express"
import { createWarehouse, getAllWarehouses } from "../controllers/warehouse.controller.js"
import { protectRoute } from "../middleware/protectRoute.js"


const router = express.Router()

router.post("/create",createWarehouse)
router.get("/get",protectRoute,getAllWarehouses)


export default router