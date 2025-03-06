import express from "express";
import morgan from "morgan";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import connectMongoDB from "./db/connectMongoDB.js";
import cors from "cors";

import authRoutes from "./routes/auth.route.js"
import productRoutes from "./routes/product.route.js"
import inventoryRoutes from "./routes/inventory.route.js"
import transactionRoutes from "./routes/transaction.route.js"
import logRoutes from "./routes/log.route.js"
import warehouseRoutes from "./routes/warehouse.route.js"
import locaionRoutes from "./routes/location.route.js"
import adminRoutes from "./routes/admin.route.js"

dotenv.config();



const app = express();
app.use(express.json());
const PORT = process.env.PORT || 5000;

app.use(morgan("tiny"));
app.use(express.json({ limit: "500mb" }));
app.use(express.urlencoded({ extended: true, limit: "500mb" }));
app.use(cookieParser());
app.use(
    cors({
        origin: "*",
        credentials: true,
    })
);

app.use("/api/auth",authRoutes)
app.use("/api/product",productRoutes)
app.use("/api/inventory",inventoryRoutes)
app.use("/api/transaction",transactionRoutes)
app.use("/api/log",logRoutes)
app.use("/api/warehouse",warehouseRoutes)
app.use("/api/location",locaionRoutes)
app.use("/api/admin",adminRoutes)


app.get("/", (req, res) => {
    res.send("Xin chào bạn");
});

app.listen(5000, () => {
    console.log(`Server is running on port ${PORT}`);
    connectMongoDB();
});