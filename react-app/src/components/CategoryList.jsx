import { useEffect, useState } from 'react';
import { fetchCategories } from '../utils/api';

const CategoryList = () => {
    const [categories, setCategories] = useState([]);

    useEffect(() => {
        const getCategories = async () => {
            try {
                const response = await fetchCategories();
                setCategories(response.data);
                console.log(response)
            } catch (error) {
                console.error('Error fetching categories:', error);
            }
        };
        getCategories();
    }, []);

    return (
        <div>
            <h2>Categories</h2>
            <ul>
                {categories.map(category => (
                    <li key={category.id}>
                        {category.category_title}
                        <ul>
                            <li>Cuisines: {category.cuisines.map(c => c.cuisine_title).join(', ')}</li>
                            {/* <li>Subcategories: {category.subcategories.map(s => s.subcategory_title).join(', ')}</li> */}
                        </ul>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default CategoryList; 