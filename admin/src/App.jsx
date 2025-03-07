import { Routes, Route, Navigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import axios from "axios";
import "./App.css";
import { Admin } from "./Admin.jsx";
import { Warehouse } from "./Warehouse.jsx";
import { Response } from "./Response.jsx";
import Login from "./auth/Login.jsx";

function ProtectedRoute({ children }) {
  const { data: authAdmin, isLoading } = useQuery({
    queryKey: ["authAdmin"],
    queryFn: async () => {
      try {
        const response = await axios.get("/api/admin/getme", {
          withCredentials: true,
        });
        if (response.data.error) {
          throw new Error(response.data.error);
        }
        return response.data;
      } catch (error) {
        if (error.response && error.response.status === 401) {
          return null;
        }
        throw error;
      }
    },
    retry: false,
  });

  if (isLoading) {
    return <div>Loading...</div>;
  }

  return authAdmin ? children : <Navigate to="/adlogin" />;
}

function App() {
  return (
    <Routes>
      <Route path="/adlogin" element={<Login />} />

   
      <Route path="/" element={<ProtectedRoute><Admin /></ProtectedRoute>} />
      <Route path="/warehouse" element={<ProtectedRoute><Warehouse /></ProtectedRoute>} />
      <Route path="/response" element={<ProtectedRoute><Response /></ProtectedRoute>} />
    </Routes>
  );
}

export default App;
