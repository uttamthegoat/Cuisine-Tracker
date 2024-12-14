import 'package:cuisineapp/screens/add_cuisine_screen.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/cuisine.dart';

class CuisineListScreen extends StatefulWidget {
  @override
  _CuisineListScreenState createState() => _CuisineListScreenState();
}

class _CuisineListScreenState extends State<CuisineListScreen> {
  late Future<List<CuisineModel>> _cuisinesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _cuisinesFuture = _fetchCuisines();
  }

  Future<List<CuisineModel>> _fetchCuisines() async {
    try {
      final response = await _apiService.fetchCuisines();
      return (response as List)
          .map((item) => CuisineModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to load cuisines: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuisines'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCuisineScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CuisineModel>>(
        future: _cuisinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cuisines available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cuisine = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ExpansionTile(
                    leading: cuisine.image != null
                        ? Image.network(
                            cuisine.image!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.restaurant),
                          )
                        : Icon(Icons.restaurant),
                    title: Text(
                      cuisine.cuisineTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      if (cuisine.categories.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Categories:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
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
          }
        },
      ),
    );
  }
}
