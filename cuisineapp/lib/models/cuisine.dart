

import 'package:cuisineapp/models/category.dart';

class CuisineBasic {
  final int id;
  final String cuisineTitle;

  CuisineBasic({
    required this.id,
    required this.cuisineTitle,
  });

  factory CuisineBasic.fromJson(Map<String, dynamic> json) {
    return CuisineBasic(
      id: json['id'] ?? 0,
      cuisineTitle: json['cuisine_title'] ?? '',
    );
  }
}

class CuisineModel {
  final int id;
  final String cuisineTitle;
  final String? image;
  late List<CategoryBasic> categories;

  CuisineModel({
    required this.id,
    required this.cuisineTitle,
    this.image,
    List<CategoryBasic>? categories,
  }) {
    this.categories = categories ?? [];
  }

  factory CuisineModel.fromJson(Map<String, dynamic> json) {
    return CuisineModel(
      id: json['id'] ?? 0,
      cuisineTitle: json['cuisine_title'] ?? '',
      image: json['image'],
      categories: (json['categories'] ?? []).map<CategoryBasic>((c) {
        return CategoryBasic.fromJson(c as Map<String, dynamic>);
      }).toList(),
    );
  }
}