import 'category.dart';

class SubcategoryBasic {
  final int id;
  final String title;

  SubcategoryBasic({
    required this.id,
    required this.title,
  });

  factory SubcategoryBasic.fromJson(Map<String, dynamic> json) {
    return SubcategoryBasic(
      id: json['id'] ?? 0,
      title: json['subcategory_title'] ?? '',
    );
  }
}

class Subcategory {
  final int id;
  final String title;
  late List<CategoryBasic> categories;

  Subcategory({
    required this.id,
    required this.title,
    List<CategoryBasic>? categories,
  }) {
    this.categories = categories ?? [];
  }

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] ?? 0,
      title: json['subcategory_title'] ?? '',
      categories: (json['categories'] ?? []).map<CategoryBasic>((c) {
        return CategoryBasic.fromJson(c as Map<String, dynamic>);
      }).toList(),
    );
  }
}
