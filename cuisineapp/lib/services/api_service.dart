import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subcategory.dart';

class ApiService {
  final String baseUrl = "http://192.168.50.41:8000/api";
  // final String baseUrl = "http://192.168.137.1:8000/api";
  
  ApiService();



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
    
    request.fields['category_title'] = title;
    request.fields['cuisine_ids'] = jsonEncode(cuisineIds);
    request.fields['subcategory_ids'] = jsonEncode(subcategoryIds);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    
    var response = await request.send();
    if (response.statusCode != 201) {
      final responseBody = await response.stream.bytesToString();
      print('Error response: $responseBody');
      throw Exception('Failed to create category: $responseBody');
    }
  }

  // Subcategory methods
  Future<List<SubcategoryModel>> fetchSubcategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/subcategories/'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('Raw API Response: $jsonData'); // Debug print
        
        return jsonData.map((data) {
          try {
            return SubcategoryModel.fromJson(data as Map<String, dynamic>);
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
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/subcategories/'),
    );

    request.fields['subcategory_title'] = title;
    request.fields['category_ids'] = jsonEncode(categoryIds);
    
    var response = await request.send();
    if (response.statusCode != 201) {
      final responseBody = await response.stream.bytesToString();
      print('Error response: $responseBody');
      throw Exception('Failed to create cuisine: $responseBody');
    }
  }

}
