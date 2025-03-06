import { Routes, Route } from "react-router-dom";
import Review from "./Review";

function App() {
  return (

      <Routes>
        <Route path='product/g/:warehouse_id/:location_id/:product_id' element={<Review />} />
      </Routes>
  
  );
}

export default App;
