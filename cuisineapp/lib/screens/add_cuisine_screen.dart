// lib/screens/add_cuisine_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCuisineScreen extends StatefulWidget {
  @override
  _AddCuisineScreenState createState() => _AddCuisineScreenState();
}

class _AddCuisineScreenState extends State<AddCuisineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
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
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Submit form
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
