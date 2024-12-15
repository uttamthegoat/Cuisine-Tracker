import { useEffect, useState } from 'react';
import { fetchCuisines } from '../utils/api';
import { Link } from 'react-router-dom';

const CuisineList = () => {
    const [cuisines, setCuisines] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const getCuisines = async () => {
            try {
                setLoading(true);
                const response = await fetchCuisines();
                setCuisines(response.data);
            } catch (error) {
                console.error('Error fetching cuisines:', error);
                setError('Failed to fetch cuisines. Please try again later.');
            } finally {
                setLoading(false);
            }
        };
        getCuisines();
    }, []);

    if (loading) {
        return (
            <div className="flex justify-center items-center min-h-screen">
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
                <h2 className="text-3xl font-extrabold text-gray-900 text-center mb-6">Cuisines</h2>
                <div className="flex justify-end mb-4">
                    <Link to="/add-cuisine" className="bg-blue-500 text-white px-4 py-2 rounded-md">
                        Add Cuisine
                    </Link>
                </div>
                {cuisines.length === 0 ? (
                    <p className="text-gray-600 text-center bg-white p-6 rounded-lg shadow-md">No cuisines available.</p>
                ) : (
                    <div className="bg-white shadow-md rounded-lg overflow-hidden">
                        <div className="overflow-x-auto">
                            <table className="min-w-full divide-y divide-gray-200">
                                <thead className="bg-gray-50">
                                    <tr>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Cuisine
                                        </th>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Image
                                        </th>
                                        <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Categories
                                        </th>
                                    </tr>
                                </thead>
                                <tbody className="bg-white divide-y divide-gray-200">
                                    {cuisines.map((cuisine) => (
                                        <tr key={cuisine.id} className="hover:bg-gray-50">
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="text-sm font-medium text-gray-900">{cuisine.cuisine_title}</div>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="text-sm font-medium text-gray-900">{cuisine.image}</div>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="text-sm text-gray-900">
                                                    {cuisine.categories.length > 0 ? (
                                                        <ul className="list-disc list-inside">
                                                            {cuisine.categories.map((category) => (
                                                                <li key={category.id}
                                                                >{category.category_title}</li>
                                                            ))}
                                                        </ul>
                                                    ) : (
                                                        <span className="text-gray-500">No associated categories</span>
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

export default CuisineList;

