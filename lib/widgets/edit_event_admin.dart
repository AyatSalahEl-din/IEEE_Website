import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'Date_picker_tile.dart';
import 'custom_text_form_field.dart';
import 'custom_elevated_button.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class EditEventPage extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> eventData;

  const EditEventPage({super.key, required this.eventId, required this.eventData});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;
  List<String> _imageUrls = [];
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.eventData['name']);
    _categoryController = TextEditingController(text: widget.eventData['category']);
    _descriptionController = TextEditingController(text: widget.eventData['details']);
    _locationController = TextEditingController(text: widget.eventData['location']);
    _timeController = TextEditingController(text: widget.eventData['time']);
    _imageUrls = List<String>.from(widget.eventData['imageUrls'] ?? []);
    _selectedDate = (widget.eventData['date'] as Timestamp).toDate();
  }

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
      'name': _nameController.text,
      'category': _categoryController.text,
      'details': _descriptionController.text,
      'location': _locationController.text,
      'time': _timeController.text,
      'date': _selectedDate,
      'month': DateFormat.MMMM().format(_selectedDate!),
      'imageUrls': _imageUrls,
    });

    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context); // go back after saving
  }

  Future<void> _addImage() async {
    TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: WebsiteColors.whiteColor,
          title: Text(
            "Enter Image URL",
            style: TextStyle(
              color: WebsiteColors.primaryBlueColor,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: urlController,
            decoration: InputDecoration(
              hintText: "Enter image URL",
              hintStyle: TextStyle(color: WebsiteColors.greyColor, fontSize: 32.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0.sp),
                borderSide: BorderSide(color: WebsiteColors.primaryBlueColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0.sp),
                borderSide: BorderSide(color: WebsiteColors.primaryBlueColor),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
              ),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final url = urlController.text.trim();
                if (url.isNotEmpty) {
                  setState(() => _imageUrls.add(url));
                }
                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 10.sp),
                foregroundColor: WebsiteColors.whiteColor,
                backgroundColor: WebsiteColors.primaryBlueColor,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        backgroundColor: WebsiteColors.primaryBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 25.sp),
              CustomTextFormField(controller: _nameController, labelText: "Event Name", icon: Icons.event),
              SizedBox(height: 25.sp),
              CustomTextFormField(controller: _categoryController, labelText: "Category", icon: Icons.category),
              SizedBox(height: 25.sp),
              CustomTextFormField(controller: _descriptionController, labelText: "Description", icon: Icons.description, isMultiline: true),
              SizedBox(height: 25.sp),
              CustomTextFormField(controller: _locationController, labelText: "Location", icon: Icons.location_on),
              SizedBox(height: 25.sp),
              CustomTextFormField(controller: _timeController, labelText: "Time", icon: Icons.access_time),
              SizedBox(height: 25.sp),

              // Use CustomDatePicker widget here
              CustomDatePicker(
                initialDate: _selectedDate,
                onDatePicked: (newDateTime) {
                  setState(() {
                    _selectedDate = newDateTime;
                  });
                },
              ),

              const SizedBox(height: 20),

              if (_imageUrls.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _imageUrls.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final url = _imageUrls[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                              onPressed: () => setState(() => _imageUrls.removeAt(index)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              const SizedBox(height: 16),

              // Add Image Button
              CustomElevatedButton(
                label: '+ Add Image',
                onPressed: _addImage,
              ),

              const SizedBox(height: 24),
              CustomElevatedButton(
                label: 'Update Event',
                onPressed: _updateEvent,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
