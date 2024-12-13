import { useEffect, useState } from 'react';
import { fetchSubcategories } from '../utils/api';

const SubcategoryList = () => {
    const [subcategories, setSubcategories] = useState([]);

    useEffect(() => {
        const getSubcategories = async () => {
            try {
                const response = await fetchSubcategories();
                setSubcategories(response.data);
            } catch (error) {
                console.error('Error fetching subcategories:', error);
            }
        };
        getSubcategories();
    }, []);

    return (
        <div>
            <h2>Subcategories</h2>
            <ul>
                {subcategories.map(subcategory => (
                    <li key={subcategory.id}>{subcategory.subcategory_title}</li>
                ))}
            </ul>
        </div>
    );
};

export default SubcategoryList; 