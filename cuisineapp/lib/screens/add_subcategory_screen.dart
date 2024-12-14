import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class AddSubcategoryScreen extends StatefulWidget {
  @override
  _AddSubcategoryScreenState createState() => _AddSubcategoryScreenState();
}

class _AddSubcategoryScreenState extends State<AddSubcategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  List<Category> _availableCategories = [];
  List<int> _selectedCategoryIds = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.fetchCategories();
      setState(() {
        _availableCategories = categories.map((c) => Category.fromJson(c)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load categories')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {

      try {
        setState(() {
          // Show loading indicator if needed
        });

        await _apiService.createSubcategory(
          title: _titleController.text,
          categoryIds: _selectedCategoryIds,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuisine created successfully')),
        );

        // Navigate back
        Navigator.pop(context, true);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create cuisine: $e')),
        );
      } finally {
        setState(() {
          // Hide loading indicator if needed
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subcategory'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Title Input
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Categories Multi-select
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropDownMultiSelect(
                      onChanged: (List<String> selected) {
                        setState(() {
                          _selectedCategoryIds = selected
                              .map((s) => _availableCategories
                                  .firstWhere((c) => c.title == s)
                                  .id)
                              .toList();
                        });
                      },
                      options: _availableCategories.map((c) => c.title).toList(),
                      selectedValues: _selectedCategoryIds
                          .map((id) => _availableCategories
                              .firstWhere((c) => c.id == id)
                              .title)
                          .toList(),
                      whenEmpty: 'Select Categories',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Create Subcategory',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
