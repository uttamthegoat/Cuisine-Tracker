import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/cuisine_provider.dart';
import 'add_cuisine_screen.dart';

class CuisineListScreen extends StatefulWidget {
  @override
  _CuisineListScreenState createState() => _CuisineListScreenState();
}

class _CuisineListScreenState extends State<CuisineListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cuisines when screen loads
    Future.microtask(() =>
        Provider.of<CuisineProvider>(context, listen: false).fetchCuisines());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuisines',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCuisineScreen()),
              ).then((value) {
                if (value == true) {
                  // Refresh list after adding new cuisine
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => 
            Provider.of<CuisineProvider>(context, listen: false).refreshCuisines(),
        child: Consumer<CuisineProvider>(
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
            
            if (provider.cuisines.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No cuisines available',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.cuisines.length,
              itemBuilder: (context, index) {
                final cuisine = provider.cuisines[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: cuisine.image != null
                        ? Image.network(
                            cuisine.image!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.restaurant),
                          )
                        : const Icon(Icons.restaurant),
                    title: Text(
                      cuisine.cuisineTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: [
                      if (cuisine.categories.isNotEmpty)
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
                                children: cuisine.categories
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
