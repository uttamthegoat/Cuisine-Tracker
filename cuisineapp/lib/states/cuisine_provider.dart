import 'package:flutter/foundation.dart';
import '../models/cuisine.dart';
import '../services/api_service.dart';

class CuisineProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CuisineModel> _cuisines = [];
  bool _isLoading = false;
  String? _error;

  List<CuisineModel> get cuisines => _cuisines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCuisines() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchCuisines();
      _cuisines = (response as List)
          .map((item) => CuisineModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCuisine(String title, String imagePath, List<int> categoryIds) async {
    try {
      await _apiService.createCuisine(
        title: title,
        imagePath: imagePath,
        categoryIds: categoryIds,
      );
      await fetchCuisines(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }


}