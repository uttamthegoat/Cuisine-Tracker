import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/subcategory.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String baseUrl = "http://192.168.50.41:8000/api";
  // final String baseUrl = "http://192.168.137.1:8000/api";
  
  ApiService();

// Cuisine methods
  Future<List<Map<String, dynamic>>> fetchCuisines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cuisines/'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Failed to load cuisines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cuisines: $e');
    }
  }

  Future<void> createCuisine({
    required String title,
    required XFile image,
    required List<int> categoryIds,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/cuisines/'),
    );
    
    request.fields['cuisine_title'] = title;
    request.fields['category_ids'] = jsonEncode(categoryIds);
    
    // Add the image file
    final imageBytes = await image.readAsBytes();
    final multipartFile = http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: image.name,
      contentType: MediaType('image', 'jpeg'), // Adjust content type as needed
    );
    request.files.add(multipartFile);
    
    var response = await request.send();
    if (response.statusCode != 201) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create cuisine: $responseBody');
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
    required XFile image,
    required List<int> cuisineIds,
    required List<int> subcategoryIds,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/categories/'),
      );
      
      // Add text fields
      request.fields['category_title'] = title;
      request.fields['cuisine_ids'] = jsonEncode([cuisineIds]); // Wrap in array as per backend expectation
      request.fields['subcategory_ids'] = jsonEncode([subcategoryIds]); // Wrap in array as per backend expectation
      
      // Add the image file
      final imageBytes = await image.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: image.name,
        contentType: MediaType('image', 'jpeg'), // Adjust content type as needed
      );
      request.files.add(multipartFile);
      
      // Send the request
      var response = await request.send();
      
      if (response.statusCode != 201) {
        final responseBody = await response.stream.bytesToString();
        print('Error response: $responseBody');
        throw Exception('Failed to create category: $responseBody');
      }
    } catch (e) {
      print('Error creating category: $e');
      throw Exception('Failed to create category: $e');
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
