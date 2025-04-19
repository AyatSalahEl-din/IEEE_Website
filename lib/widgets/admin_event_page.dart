import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/widgets/build_delete_event_widget.dart';
import 'package:ieee_website/widgets/build_edit_event_widget.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_event_admin.dart';
import 'build_add_event_widget.dart';
import 'custom_elevated_button.dart';
import 'custom_text_form_field.dart';
import 'edit_event_admin.dart';

class AdminEventPage extends StatefulWidget {
  const AdminEventPage({super.key});
  static const String routeName = 'admin';

  @override
  State<AdminEventPage> createState() => _AdminEventPageState();
}

class _AdminEventPageState extends State<AdminEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime? _selectedDate;
  List<String> _imageUrls = [];
  bool _isLoading = false;
  String? _editingEventId;

  String get _selectedMonth =>
      _selectedDate != null ? DateFormat.MMMM().format(_selectedDate!) : '';

  int _selectedIndex = 0; // To keep track of the selected tab

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2014),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _imageUrls.clear();
      _selectedDate = null;
      _isLoading = false;
      _editingEventId = null;
      _nameController.clear();
      _categoryController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _timeController.clear();
    });
  }

  Future<void> _loadEventData(String eventId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        _editingEventId = eventId;
        _nameController.text = data['name'] ?? '';
        _categoryController.text = data['category'] ?? '';
        _descriptionController.text = data['details'] ?? '';
        _locationController.text = data['location'] ?? '';
        _timeController.text = data['time'] ?? '';
        _imageUrls = List<String>.from(data['imageUrls'] ?? []);
        _selectedDate =
            (data['date'] is Timestamp)
                ? (data['date'] as Timestamp).toDate()
                : data['date'].dateTime().now();
      });
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin - Manage Events',
          style: TextStyle(color: WebsiteColors.whiteColor),
        ),
        backgroundColor: WebsiteColors.primaryBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab buttons to switch between Add, Edit, and Delete
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomElevatedButton(
                    label: 'Add Event',
                    onPressed: () => setState(() => _selectedIndex = 0),
                  ),
                  SizedBox(width: 10.sp),
                  CustomElevatedButton(
                    label: 'Edit Event',
                    onPressed: () => setState(() => _selectedIndex = 1),
                  ),
                  SizedBox(width: 10.sp),
                  CustomElevatedButton(
                    label: 'Delete Event',
                    onPressed: () => setState(() => _selectedIndex = 2),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Show content based on the selected tab
              if (_selectedIndex == 0)
                AddEventForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  categoryController: _categoryController,
                  descriptionController: _descriptionController,
                  locationController: _locationController,
                  timeController: _timeController,
                  imageUrlController: _imageUrlController,
                  imageUrls: _imageUrls,
                  selectedDate: _selectedDate,
                  selectedMonth: _selectedMonth,
                  isLoading: _isLoading,
                  setLoading: _setLoading,
                  resetForm: _resetForm,
                  pickDate: _pickDate,
                  addEvent: addEvent,
                ),
              if (_selectedIndex == 1) EditEventWidget( ),
              if (_selectedIndex == 2) BuildDeleteEventWidget(),
            ],
          ),
        ),
      ),
    );
  }




}
