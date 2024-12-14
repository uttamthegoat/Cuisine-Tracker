import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useForm } from 'react-hook-form';
import { createCuisineAsync } from '../store/slices/cuisineSlice';
import { fetchCategoriesAsync, selectAllCategories } from '../store/slices/categorySlice';

const CuisineForm = () => {
    const dispatch = useDispatch();
    const categories = useSelector(selectAllCategories);
    const [previewImage, setPreviewImage] = useState(null);
    
    const {
        register,
        handleSubmit,
        formState: { errors },
        reset
    } = useForm();

    useEffect(() => {
        dispatch(fetchCategoriesAsync());
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
        formData.append('cuisine_title', data.cuisine_title);
        
        if (data.image[0]) {
            formData.append('image', data.image[0]);
        } else {
            alert('Image is required!');
            return;
        }

        // Handle category IDs
        if (data.category_ids && data.category_ids.length > 0) {
            const categoryIds = Array.isArray(data.category_ids) 
                ? data.category_ids.map(Number) 
                : [];
            formData.append('category_ids', JSON.stringify(categoryIds));
        } else {
            formData.append('category_ids', JSON.stringify([]));
        }

        formData.forEach((value, key) => {
            console.log(`${key}: ${value}`);
        });

        try {
            await dispatch(createCuisineAsync(formData)).unwrap();
            alert('Cuisine created successfully!');
            reset();
            setPreviewImage(null);
        } catch (error) {
            console.error('Error creating cuisine:', error);
            alert('Failed to create cuisine.');
        }
    };

    return (
        <div className="max-w-lg mx-auto mt-10 p-6 bg-white shadow-lg rounded-lg">
            <h1 className="text-2xl font-bold text-gray-800 mb-4 text-center">
                Add New Cuisine
            </h1>
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                {/* Cuisine Title */}
                <div>
                    <label
                        htmlFor="cuisine-title"
                        className="block text-sm font-medium text-gray-700"
                    >
                        Cuisine Title *
                    </label>
                    <input
                        type="text"
                        id="cuisine-title"
                        placeholder="Enter cuisine title"
                        {...register('cuisine_title', { 
                            required: 'Cuisine title is required',
                            minLength: {
                                value: 2,
                                message: 'Title must be at least 2 characters'
                            },
                            maxLength: {
                                value: 50,
                                message: 'Title must not exceed 50 characters'
                            }
                        })}
                        className={`mt-1 block w-full px-4 py-2 border rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500
                            ${errors.cuisine_title ? 'border-red-500' : 'border-gray-300'}`}
                    />
                    {errors.cuisine_title && (
                        <p className="text-red-500 text-sm mt-1">
                            {errors.cuisine_title.message}
                        </p>
                    )}
                </div>

                {/* Categories Selection */}
                <div>
                    <label
                        htmlFor="categories"
                        className="block text-sm font-medium text-gray-700"
                    >
                        Select Categories (Optional)
                    </label>
                    <select
                        id="categories"
                        {...register('category_ids')}
                        multiple
                        className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                    >
                        {categories.map((category) => (
                            <option key={category.id} value={category.id}>
                                {category.category_title}
                            </option>
                        ))}
                    </select>
                    <p className="text-sm text-gray-500 mt-2">
                        Hold down Ctrl (Windows) or Command (Mac) to select multiple options.
                    </p>
                </div>

                {/* Image Upload */}
                <div>
                    <label
                        htmlFor="image"
                        className="block text-sm font-medium text-gray-700"
                    >
                        Cuisine Image *
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
                        className={`mt-1 block w-full text-sm text-gray-500
                            file:mr-4 file:py-2 file:px-4
                            file:rounded-md file:border-0
                            file:text-sm file:font-semibold
                            file:bg-blue-50 file:text-blue-700
                            hover:file:bg-blue-100
                            ${errors.image ? 'border-red-500' : ''}`}
                    />
                    {errors.image && (
                        <p className="text-red-500 text-sm mt-1">
                            {errors.image.message}
                        </p>
                    )}
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

                <button
                    type="submit"
                    className="w-full bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 transition duration-200"
                >
                    Add Cuisine
                </button>
            </form>
        </div>
    );
};

export default CuisineForm;
