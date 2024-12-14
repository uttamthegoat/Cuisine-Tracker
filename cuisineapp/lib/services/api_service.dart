import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/subcategory.dart';

class ApiService {
  final String baseUrl = "http://192.168.50.41:8000/api";
  // final String baseUrl = "http://192.168.137.1:8000/api";
  
  ApiService();

// Cuisine methods
  Future<List<dynamic>> fetchCuisines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cuisines/'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load cuisines');
      }
    } catch (e) {
      throw Exception('Failed to load cuisines: $e');
    }
  }

  Future<void> createCuisine(String title, String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/cuisines/'),
    );
    
    request.fields['title'] = title;
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    
    var response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to create cuisine');
    }
  }

  // Category methods
  Future<List<dynamic>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories/'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<void> createCategory({
    required String title,
    required String imagePath,
    required List<int> cuisineIds,
    required List<int> subcategoryIds,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/categories/'),
    );
    
    request.fields['title'] = title;
    request.fields['cuisines'] = cuisineIds.join(',');
    request.fields['subcategories'] = subcategoryIds.join(',');
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    
    var response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to create category');
    }
  }

  // Subcategory methods
  Future<List<Subcategory>> fetchSubcategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/subcategories/'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('Raw API Response: $jsonData'); // Debug print
        
        return jsonData.map((data) {
          try {
            return Subcategory.fromJson(data as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing subcategory: $e');
            print('Problematic data: $data');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to load subcategories: $e');
    }
  }

  Future<void> createSubcategory({
    required String title,
    required List<int> categoryIds,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/subcategories/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'categories': categoryIds,
      }),
    );
    
    if (response.statusCode != 201) {
      throw Exception('Failed to create subcategory');
    }
  }

  // Optional: Update methods
  Future<void> updateCategory(
    int id, {
    String? title,
    String? imagePath,
    List<int>? cuisineIds,
    List<int>? subcategoryIds,
  }) async {
    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$baseUrl/categories/$id/'),
    );
    
    if (title != null) request.fields['title'] = title;
    if (cuisineIds != null) request.fields['cuisines'] = cuisineIds.join(',');
    if (subcategoryIds != null) request.fields['subcategories'] = subcategoryIds.join(',');
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }
    
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  Future<void> updateSubcategory(
    int id, {
    String? title,
    List<int>? categoryIds,
  }) async {
    final Map<String, dynamic> updateData = {};
    if (title != null) updateData['title'] = title;
    if (categoryIds != null) updateData['categories'] = categoryIds;

    final response = await http.patch(
      Uri.parse('$baseUrl/subcategories/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateData),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update subcategory');
    }
  }

  // Optional: Delete methods
  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/categories/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }

  Future<void> deleteSubcategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/subcategories/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete subcategory');
    }
  }
}
