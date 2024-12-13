import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { fetchCuisines, createCuisine } from '../../utils/api';

export const fetchCuisinesAsync = createAsyncThunk(
  'cuisines/fetchCuisines',
  async () => {
    const response = await fetchCuisines();
    return response.data;
  }
);

export const createCuisineAsync = createAsyncThunk(
  'cuisines/createCuisine',
  async (formData) => {
    const response = await createCuisine(formData);
    return response.data;
  }
);

const cuisineSlice = createSlice({
  name: 'cuisines',
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
    clearCuisines: (state) => {
      state.items = [];
      state.status = 'idle';
      state.error = null;
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchCuisinesAsync.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(fetchCuisinesAsync.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items = action.payload;
      })
      .addCase(fetchCuisinesAsync.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      })
      .addCase(createCuisineAsync.fulfilled, (state, action) => {
        state.items.push(action.payload);
      });
  }
});

// Export actions
export const { resetStatus, clearCuisines } = cuisineSlice.actions;

// Export selectors
export const selectAllCuisines = (state) => state.cuisines.items;
export const selectCuisineStatus = (state) => state.cuisines.status;
export const selectCuisineError = (state) => state.cuisines.error;

export default cuisineSlice.reducer; 