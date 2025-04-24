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
  DateTime _selectedClassDate = DateTime.now();
  DateTime _selectedReleaseDate = DateTime.now().add(const Duration(days: 14)); // Default to 2 weeks after class date
  bool _isLoading = false;

  Future<void> _selectDate(DateTime initialDate, bool isClassDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isClassDate ? DateTime.now() : _selectedClassDate,
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      // Now select the time
      final TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );
      
      if (pickedTime != null) {
        // Combine the date and time
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        
        setState(() {
          if (isClassDate) {
            _selectedClassDate = combinedDateTime;
            // If selecting class date, automatically update release date to maintain the same time
            // but 2 weeks later if release date wasn't manually set yet
            if (_selectedReleaseDate.difference(_selectedClassDate).inDays <= 14) {
              _selectedReleaseDate = combinedDateTime.add(const Duration(days: 14));
            }
          } else {
            _selectedReleaseDate = combinedDateTime;
          }
        });
      }
    }
  }

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
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Course Dates',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Class Date & Time:', style: TextStyle(fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMMM d, yyyy - HH:mm').format(_selectedClassDate),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => _selectDate(_selectedClassDate, true),
                              child: const Text('Select'),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Release Date:', style: TextStyle(fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMMM d, yyyy').format(_selectedReleaseDate),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedReleaseDate,
                                  firstDate: _selectedClassDate,
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null && picked != _selectedReleaseDate) {
                                  setState(() {
                                    _selectedReleaseDate = picked;
                                  });
                                }
                              },
                              child: const Text('Select Date'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                              _selectedClassDate,
                              _selectedReleaseDate,
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
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to create course"))
                                );
                              }
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