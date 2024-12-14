// lib/screens/add_cuisine_screen.dart
import 'package:cuisineapp/models/category.dart';
import 'package:cuisineapp/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ApiService _apiService = ApiService();
  List<CategoryModel> _availableCategories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final categories = await _apiService.fetchCategories();
    setState(() {
      _availableCategories =
          categories.map((c) => CategoryModel.fromJson(c)).toList();
      print('Available Categories:');
    for (var category in _availableCategories) {
        print('ID: ${category.id}, Title: ${category.title}');
      }
    });
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
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      try {
        setState(() {
          // Show loading indicator if needed
        });

        await _apiService.createCuisine(
          title: _titleController.text,
          imagePath: _image!.path,
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
      appBar: AppBar(title: Text('Add Cuisine')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 200,
                fit: BoxFit.cover,
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
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
