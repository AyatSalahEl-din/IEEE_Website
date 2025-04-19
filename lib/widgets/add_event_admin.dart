import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void addEvent({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController nameController,
  required TextEditingController categoryController,
  required TextEditingController descriptionController,
  required TextEditingController locationController,
  required TextEditingController timeController,
  required List<String> imageUrls,
  required DateTime? selectedDate,
  required String? selectedMonth,
  required bool isLoading,
  required Function(bool) setLoading,
  required Function() resetForm,
}) async {
  if (!formKey.currentState!.validate()) {
    return;
  }

  setLoading(true);

  try {
    final eventData = {
      'name': nameController.text.trim(),
      'category': categoryController.text.trim(),
      'details': descriptionController.text.trim(),
      'location': locationController.text.trim(),
      'time': timeController.text.trim(),
      'imageUrls': imageUrls,
      'date': selectedDate != null ? Timestamp.fromDate(selectedDate) : null,
      'month': selectedMonth,
      //'created_at': Timestamp.now(),
    };

    // Add the event to Firebase Firestore
    await FirebaseFirestore.instance.collection('events').add(eventData);

    resetForm();

    setLoading(false);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event added successfully!')),
    );
  } catch (e) {
    setLoading(false);
    // Show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
