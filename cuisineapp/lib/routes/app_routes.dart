import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_cuisine_screen.dart';
import '../screens/add_category_screen.dart';
import '../screens/add_subcategory_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String addCuisine = '/add-cuisine';
  static const String addCategory = '/add-category';
  static const String addSubcategory = '/add-subcategory';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => HomeScreen(),
        addCuisine: (context) => AddCuisineScreen(),
        addCategory: (context) => AddCategoryScreen(),
        addSubcategory: (context) => AddSubcategoryScreen(),
      };
}
