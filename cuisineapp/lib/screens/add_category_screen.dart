import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import '../models/cuisine.dart';
import '../models/subcategory.dart';
import '../states/category_provider.dart';
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
  List<SubcategoryModel> _availableSubcategories = [];
  List<int> _selectedCuisineIds = [];
  List<int> _selectedSubcategoryIds = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final cuisines = await _apiService.fetchCuisines();
      final subcategories = await _apiService.fetchSubcategories();
      setState(() {
        _availableCuisines = cuisines
            .map((c) => CuisineModel.fromJson(c))
            .toList();
        _availableSubcategories = subcategories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
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
      await Provider.of<CategoryProvider>(context, listen: false).addCategory(
        _titleController.text,
        _image!,
        _selectedCuisineIds,
        _selectedSubcategoryIds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category created successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create category: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
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
                                  .firstWhere((c) => c.title == s)
                                  .id)
                              .toList();
                        });
                      },
                      options: _availableSubcategories.map((c) => c.title).toList(),
                      selectedValues: _selectedSubcategoryIds
                          .map((id) => _availableSubcategories
                              .firstWhere((c) => c.id == id)
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
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Save Category'),
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
