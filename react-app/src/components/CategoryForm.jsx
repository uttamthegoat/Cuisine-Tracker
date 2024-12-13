/* eslint-disable no-unused-vars */
import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useForm } from 'react-hook-form';
import { createCategoryAsync } from '../store/slices/categorySlice';
import { fetchCuisinesAsync, selectAllCuisines } from '../store/slices/cuisineSlice';
import { fetchSubcategoriesAsync, selectAllSubcategories } from '../store/slices/subcategorySlice';

const CategoryForm = () => {
    const dispatch = useDispatch();
    const cuisines = useSelector(selectAllCuisines);
    const subcategories = useSelector(selectAllSubcategories);
    const [previewImage, setPreviewImage] = useState(null);

    const {
        register,
        handleSubmit,
        formState: { errors },
        reset
    } = useForm();

    useEffect(() => {
        dispatch(fetchCuisinesAsync());
        dispatch(fetchSubcategoriesAsync());
    }, [dispatch]);

    const handleImageChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setPreviewImage(reader.result);
            };
            reader.readAsDataURL(file);
        }
    };

    const onSubmit = async (data) => {
        const formData = new FormData();
        formData.append('category_title', data.category_title);
        
        if (data.image[0]) {
            formData.append('image', data.image[0]);
        } else {
            alert('Image is required!');
            return;
        }

        // Handle cuisine IDs
        const cuisineIds = Array.isArray(data.cuisine_ids) 
            ? data.cuisine_ids.map(id => Number(id)) 
            : [];
        formData.append('cuisine_ids', JSON.stringify(cuisineIds));

        
        // Handle subcategory IDs
        if (data.subcategory_ids && data.subcategory_ids.length > 0) {
            const subcategoryIds = Array.isArray(data.subcategory_ids) 
                ? data.subcategory_ids.map(Number) 
                : [];
            formData.append('subcategory_ids', JSON.stringify(subcategoryIds));
        } else {
            formData.append('subcategory_ids', JSON.stringify([]));
        }

        try {
            await dispatch(createCategoryAsync(formData)).unwrap();
            alert('Category created successfully!');
            reset();
            setPreviewImage(null);
        } catch (error) {
            console.error('Error creating category:', error);
            alert('Failed to create category.');
        }
    };

    return (
        <div className="max-w-3xl mx-auto mt-10 p-6 bg-white shadow-lg rounded-lg">
            <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">
                Add New Category
            </h1>
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                {/* Category Title */}
                <div>
                    <label htmlFor="category-title" className="block text-sm font-medium text-gray-700">
                        Category Title
                    </label>
                    <input
                        id="category-title"
                        placeholder="Enter category title"
                        {...register('category_title', { required: 'Category title is required' })}
                        className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                    />
                    {errors.category_title && 
                        <span className="text-red-500 text-sm">{errors.category_title.message}</span>
                    }
                </div>

                {/* Image Upload */}
                <div>
                    <label htmlFor="image" className="block text-sm font-medium text-gray-700">
                        Category Image
                    </label>
                    <input
                        type="file"
                        id="image"
                        {...register('image', { required: 'Image is required' })}
                        accept="image/*"
                        onChange={(e) => {
                            register('image').onChange(e);
                            handleImageChange(e);
                        }}
                        className="mt-1 block w-full text-sm text-gray-500
                            file:mr-4 file:py-2 file:px-4
                            file:rounded-md file:border-0
                            file:text-sm file:font-semibold
                            file:bg-blue-50 file:text-blue-700
                            hover:file:bg-blue-100"
                    />
                    {errors.image && 
                        <span className="text-red-500 text-sm">{errors.image.message}</span>
                    }
                    {previewImage && (
                        <div className="mt-2">
                            <img 
                                src={previewImage} 
                                alt="Preview" 
                                className="max-w-xs h-auto rounded-lg shadow-md" 
                            />
                        </div>
                    )}
                </div>

                {/* Cuisines Selection */}
                <div>
                    <label htmlFor="cuisines" className="block text-sm font-medium text-gray-700">
                        Select Cuisines
                    </label>
                    <select
                        id="cuisines"
                        {...register('cuisine_ids', { required: 'At least one cuisine is required' })}
                        multiple
                        className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                    >
                        {cuisines.map((cuisine) => (
                            <option key={cuisine.id} value={cuisine.id}>
                                {cuisine.cuisine_title}
                            </option>
                        ))}
                    </select>
                    {errors.cuisine_ids && 
                        <span className="text-red-500 text-sm">{errors.cuisine_ids.message}</span>
                    }
                </div>

                {/* Subcategories Selection */}
                <div>
                    <label htmlFor="subcategories" className="block text-sm font-medium text-gray-700">
                        Select Subcategories
                    </label>
                    <select
                        id="subcategories"
                        {...register('subcategory_ids')}
                        multiple
                        className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                    >
                        {subcategories.map((subcategory) => (
                            <option key={subcategory.id} value={subcategory.id}>
                                {subcategory.subcategory_title}
                            </option>
                        ))}
                    </select>
                    {errors.subcategory_ids && 
                        <span className="text-red-500 text-sm">{errors.subcategory_ids.message}</span>
                    }
                </div>

                <button
                    type="submit"
                    className="w-full bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 transition duration-200"
                >
                    Add Category
                </button>
            </form>
        </div>
    );
};

export default CategoryForm;
