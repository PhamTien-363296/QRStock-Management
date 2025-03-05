import express from "express"
import { createLocation, getLocationByWareHouseId } from "../controllers/location.controller.js"
import { protectRoute } from "../middleware/protectRoute.js"


const router = express.Router()

router.post("/create/:warehouse_id",protectRoute,createLocation)
router.get("/get/:warehouse_id",protectRoute,getLocationByWareHouseId)



export default router