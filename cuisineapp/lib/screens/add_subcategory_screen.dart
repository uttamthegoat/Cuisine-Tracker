import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../states/subcategory_provider.dart';

class AddSubcategoryScreen extends StatefulWidget {
  @override
  _AddSubcategoryScreenState createState() => _AddSubcategoryScreenState();
}

class _AddSubcategoryScreenState extends State<AddSubcategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  List<CategoryModel> _availableCategories = [];
  List<int> _selectedCategoryIds = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.fetchCategories();
      setState(() {
        _availableCategories = categories
            .map((c) => CategoryModel.fromJson(c))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Provider.of<SubcategoryProvider>(context, listen: false)
          .addSubcategory(
        _titleController.text,
        _selectedCategoryIds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subcategory created successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create subcategory: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subcategory'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
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

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                            options: _availableCategories
                                .map((c) => c.title)
                                .toList(),
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
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
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
