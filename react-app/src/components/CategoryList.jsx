import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
    fetchCategoriesAsync, 
    selectAllCategories, 
    selectCategoryStatus, 
    selectCategoryError 
} from '../store/slices/categorySlice';

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
        return <div className="text-center py-4 text-lg text-blue-500">Loading...</div>;
    }

    if (status === 'failed') {
        return <div className="text-red-500 text-center py-4 text-lg">Error: {error}</div>;
    }

    return (
        <div className="max-w-6xl mx-auto my-10 p-6 bg-white shadow-lg rounded-lg">
            <h2 className="text-3xl font-bold text-gray-800 text-center mb-6">Categories</h2>
            {categories.length === 0 ? (
                <p className="text-gray-600 text-center">No categories available.</p>
            ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    {categories.map((category) => (
                        <div
                            key={category.id}
                            className="bg-gray-100 p-4 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200"
                        >
                            <h3 className="text-lg font-semibold text-gray-800 mb-2">
                                {category.category_title}
                            </h3>
                            <div>
                                <h4 className="text-md font-semibold text-gray-700">Cuisines:</h4>
                                {category.cuisines.length > 0 ? (
                                    <ul className="list-disc list-inside text-gray-700 mt-2">
                                        {category.cuisines.map((cuisine) => (
                                            <li key={cuisine.id}>{cuisine.cuisine_title}</li>
                                        ))}
                                    </ul>
                                ) : (
                                    <p className="text-sm text-gray-500">No associated cuisines.</p>
                                )}
                            </div>
                            <div>
                                <h4 className="text-md font-semibold text-gray-700">Subcategories:</h4>
                                {category.subcategories && category.subcategories.length > 0 ? (
                                    <ul className="list-disc list-inside text-gray-700 mt-2">
                                        {category.subcategories.map((subcategory) => (
                                            <li key={subcategory.id}>{subcategory.subcategory_title}</li>
                                        ))}
                                    </ul>
                                ) : (
                                    <p className="text-sm text-gray-500">No associated subcategories.</p>
                                )}
                            </div>

                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default CategoryList;
