import React, { useState } from 'react';

export const Admin = () => {
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [itemName, setItemName] = useState('');
  const [quantity, setQuantity] = useState(0);
  const [status, setStatus] = useState('');

  const handleSubmit = () => {
   
    console.log('Item Name:', itemName);
    console.log('Quantity:', quantity);
    console.log('Status:', status);

   
    setIsDialogOpen(false);
  };

 
  const items = [
    { id: 1, name: 'Laptop', quantity: 20, status: 'Đang xử lý' },
    { id: 2, name: 'Điện thoại', quantity: 15, status: 'Đã hoàn thành' },
    { id: 3, name: 'Tablet', quantity: 30, status: 'Đã xuất kho' },
    { id: 4, name: 'Máy tính để bàn', quantity: 10, status: 'Đang xử lý' },
    { id: 5, name: 'Chuột', quantity: 50, status: 'Đã hoàn thành' },
  ];

  return (
    <div className="bg-gray-100 min-h-screen p-6">
      <h1 className="text-3xl font-semibold mb-6 text-gray-800">Admin - Quản lý xuất kho</h1>

  
      <button
        onClick={() => setIsDialogOpen(true)}
        className="bg-indigo-900 text-white py-2 px-6 rounded-lg shadow-md hover:bg-indigo-700 transition-all duration-300"
      >
        Tạo Request Xuất Kho
      </button>

      <div className="mt-8 overflow-x-auto bg-white shadow-lg rounded-lg">
        <table className="min-w-full table-auto">
          <thead>
            <tr className="bg-gray-800 text-white">
              <th className="px-6 py-3 text-left">Tên Sản Phẩm</th>
              <th className="px-6 py-3 text-left">Số Lượng</th>
              <th className="px-6 py-3 text-left">Trạng Thái</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <tr
                key={item.id}
                className="hover:bg-indigo-50 transition-all duration-300"
              >
                <td className="px-6 py-4">{item.name}</td>
                <td className="px-6 py-4">{item.quantity}</td>
                <td className="px-6 py-4">
                  <span
                    className={`px-4 py-2 rounded-md text-sm font-semibold ${
                      item.status === 'Đang xử lý'
                        ? 'bg-yellow-200 text-yellow-800'
                        : item.status === 'Đã hoàn thành'
                        ? 'bg-green-200 text-green-800'
                        : 'bg-blue-200 text-blue-800'
                    }`}
                  >
                    {item.status}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

     
      {isDialogOpen && (
        <div className="fixed inset-0 bg-gray-500 bg-opacity-50 flex justify-center items-center">
          <div className="bg-white p-8 rounded-lg w-96 shadow-xl">
            <h2 className="text-xl font-semibold mb-4">Tạo Request Xuất Kho</h2>
            <div className="mb-4">
              <label className="block text-sm font-medium mb-2">Tên Sản Phẩm</label>
              <input
                type="text"
                value={itemName}
                onChange={(e) => setItemName(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
            <div className="mb-4">
              <label className="block text-sm font-medium mb-2">Số Lượng</label>
              <input
                type="number"
                value={quantity}
                onChange={(e) => setQuantity(Number(e.target.value))}
                className="w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
            <div className="mb-4">
              <label className="block text-sm font-medium mb-2">Trạng Thái</label>
              <select
                value={status}
                onChange={(e) => setStatus(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                <option value="">Chọn trạng thái</option>
                <option value="Đang xử lý">Đang xử lý</option>
                <option value="Hoàn thành">Hoàn thành</option>
                <option value="Đã xuất kho">Đã xuất kho</option>
              </select>
            </div>
            <div className="flex justify-end space-x-2">
              <button
                onClick={handleSubmit}
                className="bg-indigo-600 text-white py-2 px-6 rounded-lg shadow-md hover:bg-indigo-700 transition-all duration-300"
              >
                Lưu
              </button>
              <button
                onClick={() => setIsDialogOpen(false)}
                className="bg-gray-500 text-white py-2 px-6 rounded-lg shadow-md hover:bg-gray-600 transition-all duration-300"
              >
                Hủy
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
