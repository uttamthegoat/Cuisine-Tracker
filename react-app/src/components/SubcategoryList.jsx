import { useEffect, useState } from 'react';
import { fetchSubcategories } from '../utils/api';
import { Link } from 'react-router-dom';

const SubcategoryList = () => {
    const [subcategories, setSubcategories] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const getSubcategories = async () => {
            try {
                setLoading(true);
                const response = await fetchSubcategories();
                setSubcategories(response.data);
            } catch (error) {
                console.error('Error fetching subcategories:', error);
                setError('Failed to fetch subcategories. Please try again later.');
            } finally {
                setLoading(false);
            }
        };
        getSubcategories();
    }, []);

    if (loading) {
        return (
            <div className="flex justify-center items-center min-h-screen bg-gray-100">
                <div className="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-blue-500"></div>
            </div>
        );
    }

    if (error) {
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
                <h2 className="text-3xl font-extrabold text-gray-900 text-center mb-8">
                    Subcategories and Associated Categories
                </h2>
                <div className="flex justify-end mb-4">
                    <Link to="/add-subcategory" className="bg-blue-500 text-white px-4 py-2 rounded-md">
                        Add Subcategory
                    </Link>
                </div>
                {subcategories.length === 0 ? (
                    <p className="text-gray-600 text-center bg-white p-6 rounded-lg shadow-md">No subcategories available.</p>
                ) : (
                    <div className="bg-white shadow-md rounded-lg overflow-hidden">
                        <div className="overflow-x-auto">
                            <table className="min-w-full divide-y divide-gray-200">
                                <thead className="bg-gray-50">
                                    <tr>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Subcategory
                                        </th>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Associated Categories
                                        </th>
                                    </tr>
                                </thead>
                                <tbody className="bg-white divide-y divide-gray-200">
                                    {subcategories.map((subcategory, index) => (
                                        <tr key={subcategory.id} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="text-sm font-medium text-gray-900">{subcategory.subcategory_title}</div>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="text-sm text-gray-900">
                                                    {subcategory.categories.length > 0 ? (
                                                        <ul className="list-disc list-inside space-y-1">
                                                            {subcategory.categories.map((category) => (
                                                                <li key={category.id}>{category.category_title}</li>
                                                            ))}
                                                        </ul>
                                                    ) : (
                                                        <p className="text-sm text-gray-500">No associated categories.</p>
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

export default SubcategoryList;

