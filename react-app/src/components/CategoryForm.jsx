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
        if(data.cuisine_ids && data.cuisine_ids.length > 0) {
            const cuisineIds = Array.isArray(data.cuisine_ids) 
            ? data.cuisine_ids.map(id => Number(id)) 
            : [];
            formData.append('cuisine_ids', JSON.stringify(cuisineIds));
        } else {
            formData.append('cuisine_ids', JSON.stringify([]));
        }

        
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
  <div className="min-h-screen bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
    <div className="max-w-3xl mx-auto bg-white shadow-xl rounded-lg overflow-hidden">
      <div className="bg-gradient-to-r from-blue-500 to-blue-600 py-6 px-4 sm:px-6">
        <h1 className="text-2xl font-bold text-white text-center">
          Add New Category
        </h1>
      </div>
      <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-6">
        {/* Category Title */}
        <div>
          <label htmlFor="category-title" className="block text-sm font-medium text-gray-700">
            Category Title
          </label>
          <input
            id="category-title"
            placeholder="Enter category title"
            {...register('category_title', { required: 'Category title is required' })}
            className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 transition duration-150 ease-in-out bg-white"
          />
          {errors.category_title && 
            <span className="text-red-500 text-sm mt-1 block">{errors.category_title.message}</span>
          }
        </div>

        {/* Image Upload */}
        <div>
          <label htmlFor="image" className="block text-sm font-medium text-gray-700">
            Category Image
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
            <span className="text-red-500 text-sm mt-1 block">{errors.image.message}</span>
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

        {/* Cuisines Selection */}
        <div>
          <label htmlFor="cuisines" className="block text-sm font-medium text-gray-700">
            Select Cuisines (Optional)
          </label>
          <select
            id="cuisines"
            {...register('cuisine_ids')}
            multiple
            className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 transition duration-150 ease-in-out bg-white"
          >
            {cuisines.map((cuisine) => (
              <option key={cuisine.id} value={cuisine.id}>
                {cuisine.cuisine_title}
              </option>
            ))}
          </select>
          <p className="text-sm text-gray-500 mt-2">
            Hold down Ctrl (Windows) or Command (Mac) to select multiple options.
          </p>
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
            className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 transition duration-150 ease-in-out bg-white"
          >
            {subcategories.map((subcategory) => (
              <option key={subcategory.id} value={subcategory.id}>
                {subcategory.subcategory_title}
              </option>
            ))}
          </select>
          {errors.subcategory_ids && 
            <span className="text-red-500 text-sm mt-1 block">{errors.subcategory_ids.message}</span>
          }
        </div>

        <button
          type="submit"
          className="w-full bg-gradient-to-r from-blue-500 to-blue-600 text-white py-3 px-4 rounded-md hover:from-blue-600 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition duration-150 ease-in-out"
        >
          Add Category
        </button>
      </form>
    </div>
  </div>
);
};

export default CategoryForm;

