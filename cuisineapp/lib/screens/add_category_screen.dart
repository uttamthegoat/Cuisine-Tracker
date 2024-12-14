import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';
import '../models/cuisine.dart';
import '../models/subcategory.dart';
import '../services/api_service.dart';
import 'dart:io';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<CuisineModel> _availableCuisines = [];
  List<Subcategory> _availableSubcategories = [];
  List<int> _selectedCuisineIds = [];
  List<int> _selectedSubcategoryIds = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cuisines = await _apiService.fetchCuisines();
    final subcategories = await _apiService.fetchSubcategories();
    setState(() {
      _availableCuisines =
          cuisines.map((c) => CuisineModel.fromJson(c)).toList();
      _availableSubcategories = subcategories;
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

        await _apiService.createCategory(
          title: _titleController.text,
          imagePath: _image!.path,
          cuisineIds: _selectedCuisineIds,
          subcategoryIds: _selectedSubcategoryIds,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category created successfully')),
        );

        // Navigate back
        Navigator.pop(context, true);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create category: $e')),
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
      appBar: AppBar(title: const Text('Add Category')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 200,
                fit: BoxFit.cover,
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 16.0),
            DropDownMultiSelect(
              onChanged: (List<String> selected) {
                setState(() {
                  _selectedCuisineIds = selected
                      .map((s) => _availableCuisines
                          .firstWhere((c) => c.cuisineTitle == s)
                          .id)
                      .toList();
                });
              },
              options: _availableCuisines.map((c) => c.cuisineTitle).toList(),
              selectedValues: _selectedCuisineIds
                  .map((id) => _availableCuisines
                      .firstWhere((c) => c.id == id)
                      .cuisineTitle)
                  .toList(),
              whenEmpty: 'Select Cuisines',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            DropDownMultiSelect(
              onChanged: (List<String> selected) {
                setState(() {
                  _selectedSubcategoryIds = selected
                      .map((s) => _availableSubcategories
                          .firstWhere((sc) => sc.title == s)
                          .id)
                      .toList();
                });
              },
              options: _availableSubcategories.map((s) => s.title).toList(),
              selectedValues: _selectedSubcategoryIds
                  .map((id) => _availableSubcategories
                      .firstWhere((s) => s.id == id)
                      .title)
                  .toList(),
              whenEmpty: 'Select Subcategories',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await _apiService.createCategory(
                      title: _titleController.text,
                      imagePath: _image!.path,
                      cuisineIds: _selectedCuisineIds,
                      subcategoryIds: _selectedSubcategoryIds,
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to create category')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
