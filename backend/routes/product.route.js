import express from "express"
import { createProduct, getAllProducts } from "../controllers/product.controller.js"
const router = express.Router()

router.post("/create",createProduct)
router.get("/get",getAllProducts)

export default router