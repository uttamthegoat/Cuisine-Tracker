import { useEffect, useState } from 'react';
import { fetchSubcategories } from '../utils/api';

const SubcategoryList = () => {
    const [subcategories, setSubcategories] = useState([]);

    useEffect(() => {
        const getSubcategories = async () => {
            try {
                const response = await fetchSubcategories();
                console.log(response.data);
                setSubcategories(response.data);
            } catch (error) {
                console.error('Error fetching subcategories:', error);
            }
        };
        getSubcategories();
    }, []);

    return (
        <div className="max-w-6xl mx-auto my-10 p-6 bg-white shadow-lg rounded-lg">
            <h2 className="text-3xl font-bold text-gray-800 mb-8 text-center">
                Subcategories and Associated Categories
            </h2>
            {subcategories.length === 0 ? (
                <p className="text-gray-600 text-center">No subcategories available.</p>
            ) : (
                <div className="overflow-x-auto">
                    <table className="table-auto w-full border-collapse border border-gray-200">
                        <thead className="bg-gray-100">
                            <tr>
                                <th className="px-4 py-2 text-left text-gray-700 font-medium border border-gray-200">
                                    Subcategory
                                </th>
                                <th className="px-4 py-2 text-left text-gray-700 font-medium border border-gray-200">
                                    Associated Categories
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            {subcategories.map((subcategory, index) => (
                                <tr
                                    key={subcategory.id}
                                    className={
                                        index % 2 === 0
                                            ? 'bg-white hover:bg-gray-50'
                                            : 'bg-gray-50 hover:bg-gray-100'
                                    }
                                >
                                    <td className="px-4 py-3 text-gray-800 border border-gray-200">
                                        {subcategory.subcategory_title}
                                    </td>
                                    <td className="px-4 py-3 text-gray-700 border border-gray-200">
                                        {subcategory.categories.length > 0 ? (
                                            <ul className="list-disc list-inside space-y-1">
                                                {subcategory.categories.map((category) => (
                                                    <li key={category.id}>{category.category_title}</li>
                                                ))}
                                            </ul>
                                        ) : (
                                            <p className="text-sm text-gray-500">No associated categories.</p>
                                        )}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}
        </div>
    );
};

export default SubcategoryList;
