import 'subcategory.dart';
import 'cuisine.dart';

class CategoryBasic {
  final int id;
  final String title;

  CategoryBasic({
    required this.id,
    required this.title,
  });

  factory CategoryBasic.fromJson(Map<String, dynamic> json) {
    return CategoryBasic(
      id: json['id'] ?? 0,
      title: json['category_title'] ?? '',
    );
  }
}

class Category {
  final int id;
  final String title;
  final String? imageUrl;
  late List<CuisineBasic> cuisines;
  late List<SubcategoryBasic> subcategories;

  Category({
    required this.id,
    required this.title,
    this.imageUrl,
    List<CuisineBasic>? cuisines,
    List<SubcategoryBasic>? subcategories,
  }) {
    this.cuisines = cuisines ?? [];
    this.subcategories = subcategories ?? [];
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        id: json['id'] ?? 0,
        title: json['category_title'] ?? '',
        imageUrl: json['image'],
        cuisines: (json['cuisines'] ?? []).map<CuisineBasic>((c) {
          return CuisineBasic.fromJson(c as Map<String, dynamic>);
        }).toList(),
        subcategories: (json['subcategories'] ?? []).map<SubcategoryBasic>((s) {
          return SubcategoryBasic.fromJson(s as Map<String, dynamic>);
        }).toList(),
      );
    } catch (e) {
      print('Error parsing category: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}
