import { Routes, Route, Navigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import axios from "axios";
import "./App.css";
import { Admin } from "./Admin.jsx";
import Login from "./auth/Login.jsx";

function App() {
  const { data: authAdmin, isLoading } = useQuery({
    queryKey: ["authAdmin"],
    queryFn: async () => {
      try {
        const response = await axios.get("/api/admin/getme",{
          withCredentials: true,
        });
        if (response.data.error) {
          throw new Error(response.data.error);
          
        }
        return response.data;
      } catch (error) {
        if (error.response && error.response.status === 401) {
          console.log("Dữ liệu authUser:", authAdmin);
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



  return (
    <Routes>
   
      <Route
        path="/"
        element={authAdmin ? <Admin /> : <Navigate to="/adlogin" />}
      />
      <Route path="/adlogin" element={<Login />} />
    </Routes>
  );
}

export default App;
