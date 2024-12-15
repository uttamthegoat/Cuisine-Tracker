import { Routes, Route, Link } from "react-router-dom";
import CuisineList from "./components/CuisineList";
import CuisineForm from "./components/CuisineForm";
import CategoryList from "./components/CategoryList";
import CategoryForm from "./components/CategoryForm";
import SubcategoryList from "./components/SubcategoryList";
import SubcategoryForm from "./components/SubcategoryForm";
import "./App.css";

const App = () => {
  return (
    <div className="App flex flex-col bg-gray-100">
      <nav className="bg-blue-600 text-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex-shrink-0">
              <Link to="/" className="text-xl font-bold">Cuisine Manager</Link>
            </div>
            <div className="hidden md:block">
              <div className="ml-10 flex items-baseline space-x-4">
                <Link to="/cuisines" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-700 transition duration-150 ease-in-out">Cuisines</Link>
                <Link to="/categories" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-700 transition duration-150 ease-in-out">Categories</Link>
                <Link to="/subcategories" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-700 transition duration-150 ease-in-out">Subcategories</Link>
              </div>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
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
      </main>

      <footer className="mt-auto bg-gray-800 text-white py-4">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <p className="text-center text-sm">&copy; 2023 Cuisine Manager. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
};

export default App;

