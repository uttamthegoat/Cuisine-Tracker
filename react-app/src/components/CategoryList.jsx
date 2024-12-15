import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
    fetchCategoriesAsync, 
    selectAllCategories, 
    selectCategoryStatus, 
    selectCategoryError 
} from '../store/slices/categorySlice';
import { Link } from 'react-router-dom';

const CategoryList = () => {
    const dispatch = useDispatch();
    const categories = useSelector(selectAllCategories);
    const status = useSelector(selectCategoryStatus);
    const error = useSelector(selectCategoryError);

    useEffect(() => {
        if (status === 'idle') {
            dispatch(fetchCategoriesAsync());
        }
    }, [status, dispatch]);

    if (status === 'loading') {
        return (
            <div className="flex justify-center items-center min-h-screen">
                <div className="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-blue-500"></div>
            </div>
        );
    }

    if (status === 'failed') {
        return (
            <div className="min-h-screen flex items-center justify-center bg-gray-100">
                <div className="text-red-500 text-center p-6 bg-white rounded-lg shadow-xl">
                    <h2 className="text-2xl font-bold mb-2">Error</h2>
                    <p>{error}</p>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
            <div className="max-w-7xl mx-auto">
                <h2 className="text-3xl font-extrabold text-gray-900 text-center mb-6">Categories</h2>
                <div className="flex justify-end mb-4">
                    <Link to="/add-category" className="bg-blue-500 text-white px-4 py-2 rounded-md">
                        Add Category
                    </Link>
                </div>
                {categories.length === 0 ? (
                    <p className="text-gray-600 text-center bg-white p-6 rounded-lg shadow-md">No categories available.</p>
                ) : (
                    <div className="bg-white shadow-md rounded-lg overflow-hidden">
                        <div className="overflow-x-auto">
                            <table className="min-w-full divide-y divide-gray-200">
                                <thead className="bg-gray-50">
                                    <tr>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Category
                                        </th>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Image
                                        </th>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Cuisines
                                        </th>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Subcategories
                                        </th>
                                    </tr>
                                </thead>
                                <tbody className="bg-white divide-y divide-gray-200">
                                    {categories.map((category) => (
                                        <tr key={category.id} className="hover:bg-gray-50">
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="text-sm font-medium text-gray-900">{category.category_title}</div>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="text-sm font-medium text-gray-900">{category.image}</div>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="text-sm text-gray-900">
                                                    {category.cuisines.length > 0 ? (
                                                        <ul className="list-disc list-inside">
                                                            {category.cuisines.map((cuisine) => (
                                                                <li key={cuisine.id}>{cuisine.cuisine_title}</li>
                                                            ))}
                                                        </ul>
                                                    ) : (
                                                        <span className="text-gray-500">No associated cuisines</span>
                                                    )}
                                                </div>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="text-sm text-gray-900">
                                                    {category.subcategories && category.subcategories.length > 0 ? (
                                                        <ul className="list-disc list-inside">
                                                            {category.subcategories.map((subcategory) => (
                                                                <li key={subcategory.id}>{subcategory.subcategory_title}</li>
                                                            ))}
                                                        </ul>
                                                    ) : (
                                                        <span className="text-gray-500">No associated subcategories</span>
                                                    )}
                                                </div>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
};

export default CategoryList;

