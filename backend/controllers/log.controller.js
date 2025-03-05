import Log from "../models/log.model.js";


export const getAllLogs = async (req, res) => {
    try {
        const logs = await Log.find({}, 'user_id action timestamp') 
        .populate("user_id", "username");  

        return res.status(200).json({
            success: true,
            data: logs  
        });
    } catch (error) {
        console.error("Error fetching logs:", error);
        return res.status(500).json({ success: false, message: "Internal server error" });
    }
};
