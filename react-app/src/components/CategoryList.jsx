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
        return <div className="text-center py-4">Loading...</div>;
    }

    if (status === 'failed') {
        return <div className="text-red-500 text-center py-4">Error: {error}</div>;
    }

    return (
        <div>
            <h2>Categories</h2>
            <ul>
                {categories.map(category => (
                    <li key={category.id}>
                        {category.category_title}
                        <ul>
                            <li>Cuisines: {category.cuisines.map(c => c.cuisine_title).join(', ')}</li>
                        </ul>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default CategoryList; 