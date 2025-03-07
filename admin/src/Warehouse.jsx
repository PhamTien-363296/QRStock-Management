import React from "react";
import { Navbar } from "./Navbar";

export const Warehouse = () => {
  // Dữ liệu giả về danh sách kho hàng
  const warehouses = [
    { id: 1, name: "Kho Hà Nội", address: "123 Đống Đa, Hà Nội", status: "Hoạt động" },
    { id: 2, name: "Kho TP.HCM", address: "456 Quận 1, TP.HCM", status: "Bảo trì" },
    { id: 3, name: "Kho Đà Nẵng", address: "789 Hải Châu, Đà Nẵng", status: "Hoạt động" },
    { id: 4, name: "Kho Hải Phòng", address: "101 Lê Chân, Hải Phòng", status: "Tạm dừng" },
  ];

  return (
    <Navbar>
      <div className="bg-gray-100 min-h-screen p-6">
        <h1 className="text-3xl font-semibold mb-6 text-gray-800">Danh sách kho hàng</h1>

        {/* Bảng hiển thị warehouse */}
        <div className="overflow-x-auto bg-white shadow-lg rounded-lg">
          <table className="min-w-full table-auto">
            <thead>
              <tr className="bg-gray-800 text-white">
                <th className="px-6 py-3 text-left">Tên Kho</th>
                <th className="px-6 py-3 text-left">Địa Chỉ</th>
                <th className="px-6 py-3 text-left">Trạng Thái</th>
              </tr>
            </thead>
            <tbody>
              {warehouses.map((warehouse) => (
                <tr
                  key={warehouse.id}
                  className="hover:bg-indigo-50 transition-all duration-300"
                >
                  <td className="px-6 py-4">{warehouse.name}</td>
                  <td className="px-6 py-4">{warehouse.address}</td>
                  <td className="px-6 py-4">
                    <span
                      className={`px-4 py-2 rounded-md text-sm font-semibold ${
                        warehouse.status === "Hoạt động"
                          ? "bg-green-200 text-green-800"
                          : warehouse.status === "Bảo trì"
                          ? "bg-yellow-200 text-yellow-800"
                          : "bg-red-200 text-red-800"
                      }`}
                    >
                      {warehouse.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </Navbar>
  );
};
