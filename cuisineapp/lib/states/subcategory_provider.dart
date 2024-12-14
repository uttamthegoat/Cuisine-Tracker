import 'package:flutter/foundation.dart';
import '../models/subcategory.dart';
import '../services/api_service.dart';

class SubcategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<SubcategoryModel> _subcategories = [];
  bool _isLoading = false;
  String? _error;

  List<SubcategoryModel> get subcategories => _subcategories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSubcategories() async {
    if (_subcategories.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchSubcategories();
      _subcategories = response;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSubcategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchSubcategories();
      _subcategories = response;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSubcategory(String title, List<int> categoryIds) async {
    try {
      await _apiService.createSubcategory(
        title: title,
        categoryIds: categoryIds,
      );
      await refreshSubcategories(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
}