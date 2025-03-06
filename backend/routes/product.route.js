import express from "express"
import { createProduct, getProductByWarehouseAndLocationId, getProductByWHLCPDId } from "../controllers/product.controller.js"
import { protectRoute } from "../middleware/protectRoute.js"
const router = express.Router()

router.post("/create/:warehouse_id/:location_id", protectRoute, createProduct);
router.get("/get/:warehouse_id/:location_id",getProductByWarehouseAndLocationId)
router.get("/g/:warehouse_id/:location_id/:product_id",getProductByWHLCPDId)

export default router