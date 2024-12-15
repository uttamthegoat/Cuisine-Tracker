import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useForm } from 'react-hook-form';
import { createSubcategoryAsync } from '../store/slices/subcategorySlice';
import { fetchCategoriesAsync, selectAllCategories } from '../store/slices/categorySlice';

const SubcategoryForm = () => {
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
        formData.append('subcategory_title', data.subcategory_title);
        
        if (data.image[0]) {
            formData.append('image', data.image[0]);
        } else {
            alert('Image is required!');
            return;
        }

        if (data.category_ids && data.category_ids.length > 0) {
            const categoryIds = Array.isArray(data.category_ids) 
                ? data.category_ids.map(Number) 
                : [];
            formData.append('category_ids', JSON.stringify(categoryIds));
        } else {
            formData.append('category_ids', JSON.stringify([]));
        }

        try {
            await dispatch(createSubcategoryAsync(formData)).unwrap();
            alert('Subcategory created successfully!');
            reset();
            setPreviewImage(null);
        } catch (error) {
            console.error('Error creating subcategory:', error);
            alert('Failed to create subcategory.');
        }
    };

    return (
        <div className="min-h-screen bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
            <div className="max-w-lg mx-auto bg-white shadow-xl rounded-lg overflow-hidden">
                <div className="bg-gradient-to-r from-blue-500 to-blue-600 py-6 px-4 sm:px-6">
                    <h1 className="text-2xl font-bold text-white text-center">
                        Add New Subcategory
                    </h1>
                </div>
                <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-6">
                    {/* Subcategory Title */}
                    <div>
                        <label htmlFor="subcategory-title" className="block text-sm font-medium text-gray-700">
                            Subcategory Title *
                        </label>
                        <input
                            id="subcategory-title"
                            type="text"
                            placeholder="Enter subcategory title"
                            {...register('subcategory_title', { 
                                required: 'Subcategory title is required',
                                minLength: {
                                    value: 2,
                                    message: 'Title must be at least 2 characters'
                                },
                                maxLength: {
                                    value: 50,
                                    message: 'Title must not exceed 50 characters'
                                }
                            })}
                            className={`mt-1 block w-full px-4 py-2 bg-white border rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 transition duration-150 ease-in-out
                                ${errors.subcategory_title ? 'border-red-500' : 'border-gray-300'}`}
                        />
                        {errors.subcategory_title && 
                            <p className="mt-1 text-sm text-red-500">{errors.subcategory_title.message}</p>
                        }
                    </div>

                    {/* Image Upload */}
                    <div>
                        <label htmlFor="image" className="block text-sm font-medium text-gray-700">
                            Subcategory Image *
                        </label>
                        <div className="mt-1 flex items-center">
                            <input
                                type="file"
                                id="image"
                                {...register('image', { required: 'Image is required' })}
                                accept="image/*"
                                onChange={(e) => {
                                    register('image').onChange(e);
                                    handleImageChange(e);
                                }}
                                className="hidden"
                            />
                            <label
                                htmlFor="image"
                                className="cursor-pointer bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition duration-150 ease-in-out"
                            >
                                Choose file
                            </label>
                            <span className="ml-3 text-sm text-gray-500">
                                {previewImage ? 'Image selected' : 'No file chosen'}
                            </span>
                        </div>
                        {errors.image && 
                            <p className="mt-1 text-sm text-red-500">{errors.image.message}</p>
                        }
                        {previewImage && (
                            <div className="mt-4">
                                <img 
                                    src={previewImage} 
                                    alt="Preview" 
                                    className="max-w-full h-auto rounded-lg shadow-md" 
                                />
                            </div>
                        )}
                    </div>

                    {/* Categories Selection */}
                    <div>
                        <label htmlFor="categories" className="block text-sm font-medium text-gray-700">
                            Select Categories (Optional)
                        </label>
                        <select
                            id="categories"
                            {...register('category_ids')}
                            multiple
                            className="mt-1 block w-full px-4 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 transition duration-150 ease-in-out"
                        >
                            {categories.map((category) => (
                                <option key={category.id} value={category.id}>
                                    {category.category_title}
                                </option>
                            ))}
                        </select>
                        <p className="mt-2 text-sm text-gray-500">
                            Hold down Ctrl (Windows) or Command (Mac) to select multiple options.
                        </p>
                    </div>

                    <button
                        type="submit"
                        className="w-full bg-gradient-to-r from-blue-500 to-blue-600 text-white py-3 px-4 rounded-md hover:from-blue-600 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition duration-150 ease-in-out"
                    >
                        Add Subcategory
                    </button>
                </form>
            </div>
        </div>
    );
};

export default SubcategoryForm;
