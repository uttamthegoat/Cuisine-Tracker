import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { createCuisine } from '../utils/api';

const CuisineForm = () => {
    const [image, setImage] = useState(null);
    const [imageError, setImageError] = useState('');
    const {
        register,
        handleSubmit,
        reset,
        formState: { errors },
    } = useForm();

    const onSubmit = async (data) => {
        if (!image) {
            setImageError('Cuisine image is required');
            return;
        }
        setImageError(''); // Clear error if image is valid

        const formData = new FormData();
        formData.append('cuisine_title', data.cuisine_title);
        formData.append('image', image);

        try {
            await createCuisine(formData);
            alert('Cuisine created successfully!');
            reset();
            setImage(null);
        } catch (error) {
            console.error('Error creating cuisine:', error);
            alert('Failed to create cuisine.');
        }
    };

    return (
        <div className="max-w-lg mx-auto mt-10 p-6 bg-white shadow-lg rounded-lg">
            <h1 className="text-2xl font-bold text-gray-800 mb-4 text-center">Add New Cuisine</h1>
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                <div>
                    <label
                        htmlFor="cuisine-title"
                        className="block text-sm font-medium text-gray-700"
                    >
                        Cuisine Title
                    </label>
                    <input
                        type="text"
                        id="cuisine-title"
                        placeholder="Enter cuisine title"
                        {...register('cuisine_title', { required: 'Cuisine title is required' })}
                        className={`mt-1 block w-full px-4 py-2 border ${
                            errors.cuisine_title ? 'border-red-500' : 'border-gray-300'
                        } rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500`}
                    />
                    {errors.cuisine_title && (
                        <p className="text-red-500 text-sm mt-1">{errors.cuisine_title.message}</p>
                    )}
                </div>
                <div>
                    <label
                        htmlFor="image"
                        className="block text-sm font-medium text-gray-700"
                    >
                        Cuisine Image
                    </label>
                    <input
                        type="file"
                        id="image"
                        onChange={(e) => setImage(e.target.files[0])}
                        accept="image/*"
                        className={`mt-1 block w-full text-sm text-gray-500 ${
                            imageError ? 'border-red-500' : ''
                        }
                        file:mr-4 file:py-2 file:px-4
                        file:rounded-md file:border-0
                        file:text-sm file:font-semibold
                        file:bg-blue-50 file:text-blue-700
                        hover:file:bg-blue-100`}
                    />
                    {imageError && (
                        <p className="text-red-500 text-sm mt-1">{imageError}</p>
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
