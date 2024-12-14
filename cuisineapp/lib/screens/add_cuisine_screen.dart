// lib/screens/add_cuisine_screen.dart
import 'package:cuisineapp/models/category.dart';
import 'package:cuisineapp/services/api_service.dart';
import 'package:cuisineapp/states/category_provider.dart';
import 'package:cuisineapp/states/cuisine_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:multiselect/multiselect.dart';

class AddCuisineScreen extends StatefulWidget {
  @override
  _AddCuisineScreenState createState() => _AddCuisineScreenState();
}

class _AddCuisineScreenState extends State<AddCuisineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  List<int> _selectedCategoryIds = [];
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<CategoryModel> _availableCategories = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categories = await _apiService.fetchCategories();
      setState(() {
        _availableCategories = categories.map((c) => CategoryModel.fromJson(c)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Provider.of<CuisineProvider>(context, listen: false).addCuisine(
        _titleController.text,
        _image!.path,
        _selectedCategoryIds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuisine created successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create cuisine: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Cuisine'),
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  if (_image != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_image!.path),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Select Image'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Save Cuisine'),
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
