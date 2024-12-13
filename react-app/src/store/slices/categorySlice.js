import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { fetchCategories, createCategory } from '../../utils/api';

// Async thunk for fetching categories
export const fetchCategoriesAsync = createAsyncThunk(
  'categories/fetchCategories',
  async () => {
    const response = await fetchCategories();
    return response.data;
  }
);

// Async thunk for creating a category
export const createCategoryAsync = createAsyncThunk(
  'categories/createCategory',
  async (formData) => {
    const response = await createCategory(formData);
    return response.data;
  }
);

const categorySlice = createSlice({
  name: 'categories',
  initialState: {
    items: [],
    status: 'idle', // 'idle' | 'loading' | 'succeeded' | 'failed'
    error: null,
  },
  reducers: {
    // Reset status (useful after errors or when needed)
    resetStatus: (state) => {
      state.status = 'idle';
      state.error = null;
    },
    // Clear categories (useful for logout or cleanup)
    clearCategories: (state) => {
      state.items = [];
      state.status = 'idle';
      state.error = null;
    }
  },
  extraReducers: (builder) => {
    builder
      // Fetch categories cases
      .addCase(fetchCategoriesAsync.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(fetchCategoriesAsync.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items = action.payload;
        state.error = null;
      })
      .addCase(fetchCategoriesAsync.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      })
      // Create category cases
      .addCase(createCategoryAsync.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(createCategoryAsync.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items.push(action.payload);
        state.error = null;
      })
      .addCase(createCategoryAsync.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      });
  },
});

// Export actions
export const { resetStatus, clearCategories } = categorySlice.actions;

// Selectors
export const selectAllCategories = (state) => state.categories.items;
export const selectCategoryStatus = (state) => state.categories.status;
export const selectCategoryError = (state) => state.categories.error;

export default categorySlice.reducer; 