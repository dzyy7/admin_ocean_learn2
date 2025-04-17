import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCourseScreen extends StatefulWidget {
  final CourseService lessonService;

  const AddCourseScreen({Key? key, required this.lessonService})
      : super(key: key);

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Course'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Course Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Video URL',
                    border: OutlineInputBorder(),
                    hintText: 'https://example.com/video',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      bool validURL = Uri.tryParse(value)?.hasAbsolutePath ?? false;
                      if (!validURL) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Class Date: ${DateFormat('MMMM d yyyy').format(_selectedDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _isLoading 
                      ? null 
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            
                            final result = await widget.lessonService.createLesson(
                              _titleController.text,
                              _descriptionController.text,
                              _urlController.text,
                              _selectedDate,
                            );
                            
                            setState(() {
                              _isLoading = false;
                            });
                            
                            if (result != null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Course created successfully"))
                                );
                                Navigator.pop(context, true);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Failed to create course"))
                              );
                            }
                          }
                        },
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create Course',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}