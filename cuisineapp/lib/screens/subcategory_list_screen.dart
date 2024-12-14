import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/subcategory_provider.dart';
import 'add_subcategory_screen.dart';

class SubcategoryListScreen extends StatefulWidget {
  @override
  _SubcategoryListScreenState createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SubcategoryProvider>(context, listen: false).fetchSubcategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subcategories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSubcategoryScreen(),
                ),
              ).then((value) {
                if (value == true) {
                  // Refresh list after adding new subcategory
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<SubcategoryProvider>(context, listen: false)
                .refreshSubcategories(),
        child: Consumer<SubcategoryProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              );
            }

            if (provider.subcategories.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No subcategories available.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = provider.subcategories[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.list,
                      size: 36,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      subcategory.title,
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
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Categories:',
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
                              children: subcategory.categories
                                  .map((category) => Chip(
                                        label: Text(category.title),
                                        backgroundColor: Colors.grey[200],
                                      ))
                                  .toList(),
                            ),
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
