/* eslint-disable no-unused-vars */
import { useEffect, useState } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { createSubcategory, fetchCategories } from '../utils/api';

const SubcategoryForm = () => {
    const [categories, setCategories] = useState([]);
    const [previewImage, setPreviewImage] = useState(null);
    const { control, handleSubmit, reset, formState: { errors } } = useForm({
        defaultValues: {
            subcategory_title: '',
            category_ids: [],
            image: null
        },
        mode: 'onBlur'
    });

    useEffect(() => {
        const getCategories = async () => {
            try {
                const response = await fetchCategories();
                setCategories(response.data);
            } catch (error) {
                console.error('Error fetching categories:', error);
            }
        };
        getCategories();
    }, []);

    const handleImageChange = (e, onChange) => {
        const file = e.target.files[0];
        if (file) {
            onChange(e.target.files); // for react-hook-form
            // Create preview
            const reader = new FileReader();
            reader.onloadend = () => {
                setPreviewImage(reader.result);
            };
            reader.readAsDataURL(file);
        }
    };

    const onSubmit = async (data) => {
        try {
            const formData = new FormData();
            formData.append('subcategory_title', data.subcategory_title);
            
            // Handle image
            if (data.image && data.image[0]) {
                formData.append('image', data.image[0]);
            }

            const category_ids = Array.isArray(data.category_ids) 
            ? data.category_ids.map(id => Number(id)) 
            : [];

            formData.append('category_ids', JSON.stringify(category_ids));
            formData.forEach((value, key) => {
                console.log(`${key}: ${value}`);
            });

            await createSubcategory(formData);
            alert('Subcategory created successfully!');
            // setPreviewImage(null);
            // reset();
        } catch (error) {
            console.error('Error creating subcategory:', error);
            alert('Failed to create subcategory.');
        }
    };

    return (
        <div className="max-w-3xl mx-auto mt-10 p-6 bg-white shadow-lg rounded-lg">
            <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">Add New Subcategory</h1>
            
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                {/* Subcategory Title */}
                <div>
                    <label htmlFor="subcategory_title" className="block text-sm font-medium text-gray-700">
                        Subcategory Title *
                    </label>
                    <Controller
                        name="subcategory_title"
                        control={control}
                        rules={{ 
                            required: 'Subcategory title is required',
                            minLength: {
                                value: 2,
                                message: 'Title must be at least 2 characters'
                            },
                            maxLength: {
                                value: 50,
                                message: 'Title must not exceed 50 characters'
                            }
                        }}
                        render={({ field }) => (
                            <input
                                {...field}
                                type="text"
                                id="subcategory_title"
                                placeholder="Enter subcategory title"
                                className={`mt-1 block w-full px-4 py-2 border rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 
                                    ${errors.subcategory_title ? 'border-red-500' : 'border-gray-300'}`}
                            />
                        )}
                    />
                    {errors.subcategory_title && (
                        <p className="mt-1 text-sm text-red-600">{errors.subcategory_title.message}</p>
                    )}
                </div>

                {/* Categories Selection */}
                <div>
                    <label htmlFor="category_ids" className="block text-sm font-medium text-gray-700">
                        Select Categories *
                    </label>
                    <Controller
                        name="category_ids"
                        control={control}
                        rules={{ 
                            required: 'Please select at least one category',
                            validate: value => value.length > 0 || 'At least one category must be selected'
                        }}
                        render={({ field: { onChange, value } }) => (
                            <select
                                multiple
                                id="category_ids"
                                value={value}
                                onChange={(e) => {
                                    const selectedOptions = [...e.target.selectedOptions];
                                    onChange(selectedOptions.map(option => option.value));
                                }}
                                className={`mt-1 block w-full px-4 py-2 border rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500
                                    ${errors.category_ids ? 'border-red-500' : 'border-gray-300'}`}
                            >
                                {categories.map((category) => (
                                    <option key={category.id} value={category.id}>
                                        {category.category_title}
                                    </option>
                                ))}
                            </select>
                        )}
                    />
                    {errors.category_ids && (
                        <p className="mt-1 text-sm text-red-600">{errors.category_ids.message}</p>
                    )}
                    <p className="text-sm text-gray-500 mt-2">
                        Hold down Ctrl (Windows) or Command (Mac) to select multiple options.
                    </p>
                </div>

                {/* Image Upload */}
                <div>
                    <label htmlFor="image" className="block text-sm font-medium text-gray-700">
                        Subcategory Image *
                    </label>
                    <Controller
                        name="image"
                        control={control}
                        rules={{
                            required: 'Please select an image',
                            validate: {
                                fileSize: value => {
                                    if (!value || !value[0]) return 'Please select an image';
                                    return value[0].size <= 5000000 || 'Image must be less than 5MB';
                                },
                                fileType: value => {
                                    if (!value || !value[0]) return 'Please select an image';
                                    return ['image/jpeg', 'image/png', 'image/gif'].includes(value[0].type) || 
                                        'Only JPG, PNG and GIF files are allowed';
                                }
                            }
                        }}
                        render={({ field: { onChange, value, ...field } }) => (
                            <div className="space-y-4">
                                <input
                                    {...field}
                                    type="file"
                                    id="image"
                                    accept="image/*"
                                    onChange={(e) => handleImageChange(e, onChange)}
                                    className={`mt-1 block w-full px-4 py-2 border rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500
                                        ${errors.image ? 'border-red-500' : 'border-gray-300'}`}
                                />
                                {errors.image && (
                                    <p className="mt-1 text-sm text-red-600">{errors.image.message}</p>
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
                        )}
                    />
                </div>

                <button
                    type="submit"
                    className="w-full bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 transition duration-200"
                >
                    Add Subcategory
                </button>
            </form>
        </div>
    );
};

export default SubcategoryForm;
