import axios from 'axios';

const API_URL = 'http://localhost:8000/api/'; // Adjust based on your Django API URL

export const fetchCuisines = () => axios.get(`${API_URL}cuisines/`);
export const fetchCategories = () => axios.get(`${API_URL}categories/`);
export const fetchSubcategories = () => axios.get(`${API_URL}subcategories/`);

export const createCuisine = (data) => axios.post(`${API_URL}cuisines/`, data);
export const createCategory = (data) => axios.post(`${API_URL}categories/`, data);
export const createSubcategory = (data) => axios.post(`${API_URL}subcategories/`, data);
