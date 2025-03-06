import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import axios from "axios";

const Review = () => {
  const { warehouse_id, location_id } = useParams(); 
  console.log(location_id)
  console.log(warehouse_id)
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        const response = await axios.get(
          `/api/product/get/${warehouse_id}/${location_id}`
        );
        
        if (response.data.success) {
          setProduct(response.data.products[0]); 
        } else {
          setProduct(null);
        }
      } catch (error) {
        console.error("Lỗi khi tải sản phẩm:", error);
        setProduct(null);
      } finally {
        setLoading(false);
      }
    };

    fetchProduct();
  }, [warehouse_id, location_id]);

  if (loading)
    return (
      <div className="flex justify-center items-center h-screen bg-gray-200">
        <p className="text-gray-700 text-lg">Đang tải...</p>
      </div>
    );

  if (!product)
    return (
      <div className="flex justify-center items-center h-screen bg-gray-200">
        <p className="text-red-600 text-lg">Không tìm thấy sản phẩm.</p>
      </div>
    );

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-200">
      <div className="max-w-lg w-full bg-white shadow-md rounded-2xl py-8 px-6 border border-gray-300 min-h-[500px] flex flex-col justify-between">
      
        <div className="pb-4 border-b border-gray-300 text-center">
          <h2 className="text-3xl font-bold text-gray-900 uppercase tracking-wide">
            {product.name}
          </h2>
          <p className="text-gray-700 text-sm mt-1">{product.description}</p>
        </div>

        <div className="pt-4 space-y-3 text-gray-800 flex-grow">
          <p>
            <span className="font-bold text-gray-900 mr-2">Vị trí kho:</span> 
            <span className="text-gray-700">{product.warehouse_name}</span>
          </p>
          <p>
            <span className="font-bold text-gray-900 mr-2">Kệ:</span> 
            <span className="text-gray-700">{product.location_shelf}</span>
          </p>
          <p>
            <span className="font-bold text-gray-900 mr-2">Hộc:</span> 
            <span className="text-gray-700">{product.location_bin}</span>
          </p>
          <p>
            <span className="font-bold text-gray-900 mr-2">Số lượng:</span> 
            <span className="text-gray-700">{product.quantity}</span>
          </p>
        </div>
      </div>
    </div>
  );
};

export default Review;
