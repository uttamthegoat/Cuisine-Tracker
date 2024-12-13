import { useEffect, useState } from 'react';
import { fetchCuisines } from '../utils/api';


const CuisineList = () => {
    const [cuisines, setCuisines] = useState([]);

    useEffect(() => {
        const getCuisines = async () => {
            try {
                const response = await fetchCuisines();
                setCuisines(response.data);
            } catch (error) {
                console.error('Error fetching cuisines:', error);
            }
        };
        getCuisines();
    }, []);

    return (
        <div>
            <h2 className="text-2xl font-bold">Cuisines</h2>
            <ul>
                {cuisines.map(cuisine => (
                    <li key={cuisine.id}>{cuisine.cuisine_title}</li>
                ))}
            </ul>
        </div>
    );
};

export default CuisineList; 