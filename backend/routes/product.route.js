import express from "express"
import { createProduct, getAllProducts } from "../controllers/product.controller.js"
import { protectRoute } from "../middleware/protectRoute.js"
const router = express.Router()

router.post("/create/:warehouse_id/:location_id", protectRoute, createProduct);
router.get("/get",getAllProducts)

export default router