import express from "express"
import { getAllTransaction } from "../controllers/transaction.controller.js"
import { protectRoute } from "../middleware/protectRoute.js"


const router = express.Router()

router.get("/get",getAllTransaction)


export default router