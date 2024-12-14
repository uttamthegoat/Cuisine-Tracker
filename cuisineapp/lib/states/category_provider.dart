import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchCategories();
      _categories = response.map((item) => CategoryModel.fromJson(item)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String title, String imagePath, List<int> cuisineIds, List<int> subcategoryIds) async {
    try {
      await _apiService.createCategory(
        title: title,
        imagePath: imagePath,
        cuisineIds: cuisineIds,
        subcategoryIds: subcategoryIds,
      );
      await fetchCategories(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
}