import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/category_provider.dart';
import 'add_category_screen.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CategoryProvider>(context, listen: false).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen()),
              ).then((value) {
                if (value == true) {
                  // Refresh list after adding new category
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<CategoryProvider>(context, listen: false).refreshCategories(),
        child: Consumer<CategoryProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${provider.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (provider.categories.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No categories available.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.categories.length,
              itemBuilder: (context, index) {
                final category = provider.categories[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: category.imageUrl != null
                        ? Image.network(
                            category.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                                  Icons.category,
                                  color: Theme.of(context).primaryColor,
                                  size: 36,
                                ),
                          )
                        : Icon(
                            Icons.category,
                            color: Theme.of(context).primaryColor,
                            size: 36,
                          ),
                    title: Text(
                      category.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (category.cuisines.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.fastfood,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Cuisines:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: category.cuisines
                                    .map((cuisine) => Chip(
                                          label: Text(cuisine.cuisineTitle),
                                          backgroundColor: Colors.orange[100],
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                            ],
                            if (category.subcategories.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.subdirectory_arrow_right,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Subcategories:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: category.subcategories
                                    .map((subcategory) => Chip(
                                          label: Text(subcategory.title),
                                          backgroundColor: Colors.blue[100],
                                        ))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
