import { Routes, Route } from "react-router-dom";
import Review from "./Review";

function App() {
  return (

      <Routes>
        <Route path='product/get/:warehouse_id/:location_id' element={<Review />} />
      </Routes>
  
  );
}

export default App;
