import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import axios from "axios";

const Review = () => {
  const { warehouse_id, location_id,product_id } = useParams();
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        const response = await axios.get(
          `/api/product/g/${warehouse_id}/${location_id}/${product_id}`
        );
        
        if (response.data.success && response.data.products.length > 0) {
          setProduct(response.data.products[0]);
        } else {
          setProduct(null);
          setError("Không tìm thấy sản phẩm.");
        }
      } catch (error) {
        console.error("Lỗi khi tải sản phẩm:", error);
        setError("Có lỗi khi tải dữ liệu, vui lòng thử lại.");
      } finally {
        setLoading(false);
      }
    };

    fetchProduct();
  }, [warehouse_id, location_id, product_id]);

  if (loading)
    return (
      <div className="flex justify-center items-center h-screen bg-gradient-to-b from-blue-50 to-white">
        <p className="text-gray-700 text-lg font-semibold animate-pulse">
          Đang tải...
        </p>
      </div>
    );

  if (error)
    return (
      <div className="flex justify-center items-center h-screen bg-gradient-to-b from-blue-50 to-white">
        <p className="text-red-600 text-lg font-semibold">{error}</p>
      </div>
    );

  // Chuyển đổi ngày nhập hàng thành định dạng dễ đọc hơn
  const formattedDate = product.createdAt
    ? new Date(product.createdAt).toLocaleString("vi-VN")
    : "Không rõ";

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-b from-blue-50 to-white">
      <div className="max-w-lg w-full bg-white shadow-lg rounded-xl py-8 px-6 border border-gray-300 min-h-[500px] flex flex-col">
        <div className="pb-4 border-b border-gray-200 text-center">
          <h2 className="text-3xl font-bold text-gray-800 uppercase tracking-wide">
            {product.name || "Không có tên"}
          </h2>
          <p className="text-gray-600 text-sm mt-1">
            {product.description || "Không có mô tả"}
          </p>
        </div>

        <div className="pt-6 grid grid-cols-2 gap-y-4 gap-x-3 text-gray-800">
          <span className="font-bold text-green-950">Vị trí kho:</span>
          <span className="text-gray-700 font-semibold">
            {product.warehouse_name || "Không có"}
          </span>

          <span className="font-bold text-green-950">Kệ:</span>
          <span className="text-gray-700 font-semibold">
            {product.location_shelf || "Không có"}
          </span>

          <span className="font-bold text-green-950">Hộc:</span>
          <span className="text-gray-700 font-semibold">
            {product.location_bin || "Không có"}
          </span>

          <span className="font-bold text-green-950">Số lượng:</span>
          <span className="text-gray-700 font-semibold">
            {product.quantity ?? "Không rõ"}
          </span>

          <span className="font-bold text-green-950">Lô hàng:</span>
          <span className="text-gray-700 font-semibold">
            {product.batch || "Không có batch"}
          </span>

          <span className="font-bold text-green-950">Ngày nhập hàng:</span>
          <span className="text-gray-700 font-semibold">{formattedDate}</span>
        </div>
      </div>
    </div>
  );
};

export default Review;
