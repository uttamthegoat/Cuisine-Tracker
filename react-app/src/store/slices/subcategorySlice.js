import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { fetchSubcategories, createSubcategory } from '../../utils/api';

export const fetchSubcategoriesAsync = createAsyncThunk(
  'subcategories/fetchSubcategories',
  async () => {
    const response = await fetchSubcategories();
    return response.data;
  }
);

export const createSubcategoryAsync = createAsyncThunk(
  'subcategories/createSubcategory',
  async (formData) => {
    const response = await createSubcategory(formData);
    return response.data;
  }
);

const subcategorySlice = createSlice({
  name: 'subcategories',
  initialState: {
    items: [],
    status: 'idle',
    error: null
  },
  reducers: {
    resetStatus: (state) => {
      state.status = 'idle';
      state.error = null;
    },
    clearSubcategories: (state) => {
      state.items = [];
      state.status = 'idle';    
      state.error = null;
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchSubcategoriesAsync.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(fetchSubcategoriesAsync.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items = action.payload;
      })
      .addCase(fetchSubcategoriesAsync.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      })
      .addCase(createSubcategoryAsync.fulfilled, (state, action) => {
        state.items.push(action.payload);
      });
  }
});

// Export actions
export const { resetStatus, clearSubcategories } = subcategorySlice.actions;

// Export selectors
export const selectAllSubcategories = (state) => state.subcategories.items;
export const selectSubcategoryStatus = (state) => state.subcategories.status;
export const selectSubcategoryError = (state) => state.subcategories.error;

export default subcategorySlice.reducer; 