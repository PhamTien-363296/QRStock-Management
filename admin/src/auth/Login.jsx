import { MdPersonOutline } from "react-icons/md"; 
import { FiLock } from "react-icons/fi";
import axios from "axios";
import { useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { useNavigate } from "react-router-dom"; 

const Login = () => {
  const [name, setname] = useState("");
  const [password, setpassword] = useState("");
  const [thongBao, setThongBao] = useState("");

  const queryClient = useQueryClient();
  const navigate = useNavigate(); 

  const handleDangNhap = async (e) => {
    e.preventDefault();

    if (!name || !password) {
      setThongBao("Vui lòng nhập tên đăng nhập và mật khẩu!");
      return;
    }

    try {
      const response = await axios.post("/api/admin/login", {
        name,
        password,
      });

      setThongBao("Đăng nhập thành công!");
      console.log(response.data);

      queryClient.invalidateQueries({ queryKey: ["authAdmin"] });

      
      setTimeout(() => {
        navigate("/"); 
      }, 1000); 
    } catch (error) {
      if (error.response) {
        setThongBao(error.response.data.message || "Lỗi đăng nhập. Vui lòng thử lại!");
      } else {
        setThongBao("Lỗi không xác định. Vui lòng thử lại sau!");
      }
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen relative">
      <img
        src="https://c.wallhere.com/photos/b1/08/nature_forest_waterfall-2304284.jpg!d"
        alt="Background"
        className="!absolute !inset-0 !w-full !h-full !object-cover"
      />

      <div className="!bg-white/30 !backdrop-blur-[1px] !p-8 !rounded-lg !shadow-lg !w-full !max-w-sm !z-10">
        <h2 className="!text-2xl !font-semibold !text-center !text-gray-800 !mb-6">Login</h2>
        <form onSubmit={handleDangNhap}>
          <div className="!mb-4">
            <label className="!block !text-gray-700 !text-sm !font-bold !mb-2" htmlFor="name">
              Tên Đăng Nhập
            </label>
            <div className="!relative">
              <span className="!absolute !inset-y-0 !left-0 !flex !items-center !pl-3 !text-gray-500">
                <MdPersonOutline size={22} color="#1F3441" />
              </span>
              <input
                id="name"
                type="text"
                placeholder="Tên Đăng Nhập"
                value={name}
                onChange={(e) => setname(e.target.value)}
                className="!pl-10 !w-full !p-2 !border-b !border-black !bg-transparent focus:outline-none"
              />
            </div>
          </div>
          <div className="!mb-6">
            <label className="!block !text-gray-700 !text-sm !font-bold !mb-2" htmlFor="password">
              Mật Khẩu
            </label>
            <div className="!relative">
              <span className="!absolute !inset-y-0 !left-0 !flex !items-center !pl-3 !text-gray-500">
                <FiLock size={22} color="#1F3441" />
              </span>
              <input
                id="password"
                type="password"
                placeholder="Mật Khẩu"
                value={password}
                onChange={(e) => setpassword(e.target.value)}
                className="!pl-10 !w-full !p-2 !border-b !bg-transparent !border-black focus:outline-none"
              />
            </div>
          </div>
          <button
            type="submit"
            className="!w-full !bg-white !text-black !font-bold !py-2 !px-4 !rounded-lg !hover:bg-slate-100 !transition !duration-200"
          >
            Login
          </button>
        </form>

        {thongBao && <p className="!text-center !text-red-500 !mt-4">{thongBao}</p>}
      </div>
    </div>
  );
};

export default Login;
