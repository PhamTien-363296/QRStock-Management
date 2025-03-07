import Request from "../models/request.model.js";


export const createRequest = async (req, res) => {
  try {
    const { warehouse_id, product_id, quantity, reason } = req.body;

    const newRequest = new Request({ warehouse_id, product_id, quantity, reason });
    await newRequest.save();

    res.status(201).json({ message: "Request created successfully", data: newRequest });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


export const getAllRequests = async (req, res) => {
  try {
    const requests = await Request.find().populate("warehouse_id product_id");
    res.status(200).json(requests);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


export const deleteRequest = async (req, res) => {
  try {
    const { id } = req.params;
    await Request.findByIdAndDelete(id);
    res.status(200).json({ message: "Request deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
