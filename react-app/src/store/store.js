import { configureStore } from '@reduxjs/toolkit';
import categoryReducer from './slices/categorySlice';
import subcategoryReducer from './slices/subcategorySlice';
import cuisineReducer from './slices/cuisineSlice';

export const store = configureStore({
  reducer: {
    categories: categoryReducer,
    subcategories: subcategoryReducer,
    cuisines: cuisineReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      thunk: true,
    }),
});
