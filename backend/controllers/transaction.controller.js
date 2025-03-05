import Transaction from "../models/transaction.model.js";

export const getAllTransaction = async (req, res) => {
    try {
        const transactions = await Transaction.find({}, "user_id product_id transaction_type quantity")
            .populate("user_id", "username")  

        return res.status(200).json({
            success: true,
            data: transactions
        });
    } catch (error) {
        console.error("Error fetching transactions:", error);
        return res.status(500).json({ success: false, message: "Internal server error" });
    }
};
