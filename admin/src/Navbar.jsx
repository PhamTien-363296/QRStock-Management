import { Link } from "react-router-dom";

export const Navbar = ({ children }) => {
  return (
    <div>
   
      <nav className="bg-gray-800 text-white p-4 flex space-x-6">
        <Link to="/" className="hover:text-gray-300">Home</Link>
        <Link to="/warehouse" className="hover:text-gray-300">Warehouse</Link>
        <Link to="/response" className="hover:text-gray-300">Response</Link>
      </nav>

   
      <div className="p-6">{children}</div>
    </div>
  );
};
