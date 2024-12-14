import 'package:flutter/material.dart';
import '../models/subcategory.dart';
import '../services/api_service.dart';
import 'add_subcategory_screen.dart';

class SubcategoryListScreen extends StatefulWidget {
  @override
  _SubcategoryListScreenState createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  late Future<List<SubcategoryModel>> _subcategoriesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = _apiService.fetchSubcategories();
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
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _subcategoriesFuture = _apiService.fetchSubcategories();
          });
        },
        child: FutureBuilder<List<SubcategoryModel>>(
          future: _subcategoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No subcategories available.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final subcategory = snapshot.data![index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.category,
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
                      subtitle: Text(
                        'Categories: ${subcategory.categories.map((c) => c.title).join(', ')}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      // trailing: Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: Colors.grey,
                      //   size: 16,
                      // ),
                      // onTap: () {
                      //   // Handle item tap if needed
                      // },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
