import { Routes, Route } from "react-router-dom";
import CuisineList from "./components/CuisineList";
import CuisineForm from "./components/CuisineForm";
import CategoryList from "./components/CategoryList";
import CategoryForm from "./components/CategoryForm";
import SubcategoryList from "./components/SubcategoryList";
import SubcategoryForm from "./components/SubcategoryForm";
import "./App.css";

const App = () => {
  return (
    <div className="App">
      <h1>Cuisine Manager</h1>
      <div>
        <Routes>
          <Route path="/" element={<CuisineList />} />
          <Route path="/cuisines" element={<CuisineList />} />
          <Route path="/add-cuisine" element={<CuisineForm />} />
          <Route path="/categories" element={<CategoryList />} />
          <Route path="/add-category" element={<CategoryForm />} />
          <Route path="/subcategories" element={<SubcategoryList />} />
          <Route path="/add-subcategory" element={<SubcategoryForm />} />
        </Routes>
      </div>
    </div>
  );
};

export default App;
