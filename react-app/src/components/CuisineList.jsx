import { useEffect, useState } from 'react';
import { fetchCuisines } from '../utils/api';

const CuisineList = () => {
    const [cuisines, setCuisines] = useState([]);

    useEffect(() => {
        const getCuisines = async () => {
            try {
                const response = await fetchCuisines();
                setCuisines(response.data);
                console.log(response.data);
            } catch (error) {
                console.error('Error fetching cuisines:', error);
            }
        };
        getCuisines();
    }, []);

    return (
        <div className="max-w-6xl mx-auto my-10 p-6 bg-white shadow-lg rounded-lg">
            <h2 className="text-3xl font-bold text-gray-800 text-center mb-6">Cuisines</h2>
            {cuisines.length === 0 ? (
                <p className="text-gray-600 text-center">No cuisines available.</p>
            ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    {cuisines.map((cuisine) => (
                        <div
                            key={cuisine.id}
                            className="bg-gray-100 p-4 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200"
                        >
                            <h3 className="text-lg font-semibold text-gray-800 mb-2">
                                {cuisine.cuisine_title}
                            </h3>
                            <img
                                src={cuisine.image || 'https://via.placeholder.com/150'}
                                alt={cuisine.cuisine_title}
                                className="w-full h-32 object-cover rounded-md mb-4"
                            />
                            <div>
                                <h4 className="text-md font-semibold text-gray-700">Categories:</h4>
                                {cuisine.categories.length > 0 ? (
                                    <ul className="list-disc list-inside text-gray-700 mt-2">
                                        {cuisine.categories.map((category) => (
                                            <li key={category.id}>{category.category_title}</li>
                                        ))}
                                    </ul>
                                ) : (
                                    <p className="text-sm text-gray-500">No associated categories.</p>
                                )}
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default CuisineList;
