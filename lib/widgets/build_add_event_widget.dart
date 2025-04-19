// add_event_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Themes/website_colors.dart';
import 'Date_picker_tile.dart';
import 'custom_text_form_field.dart';

class AddEventForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final TextEditingController timeController;
  final TextEditingController imageUrlController;
  final List<String> imageUrls;
  final DateTime? selectedDate;
  final String? selectedMonth;
  final bool isLoading;
  final Function setLoading;
  final Function resetForm;
  final Function pickDate;
  final Function addEvent;

  const AddEventForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.categoryController,
    required this.descriptionController,
    required this.locationController,
    required this.timeController,
    required this.imageUrlController,
    required this.imageUrls,
    required this.selectedDate,
    required this.selectedMonth,
    required this.isLoading,
    required this.setLoading,
    required this.resetForm,
    required this.pickDate,
    required this.addEvent,
  });

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate; // Initial value from parent
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: widget.nameController,
            labelText: 'Event Name',
            icon: Icons.event,
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Enter event name' : null,
          ),
          SizedBox(height: 30.sp),
          CustomTextFormField(
            controller: widget.categoryController,
            labelText: 'Category',
            icon: Icons.category_outlined,
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Enter category' : null,
          ),
          SizedBox(height: 30.sp),
          CustomTextFormField(
            controller: widget.descriptionController,
            labelText: 'Description',
            icon: Icons.description,
            isMultiline: true,
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Enter description' : null,
          ),
          SizedBox(height: 30.sp),
          CustomTextFormField(
            controller: widget.locationController,
            labelText: 'Location',
            icon: Icons.location_on,
          ),
          SizedBox(height: 30.sp),
          CustomTextFormField(
            controller: widget.timeController,
            labelText: 'Time (e.g. 3:00 PM)',
            icon: Icons.access_time,
          ),
          SizedBox(height: 30.sp),
          CustomDatePicker(
            initialDate: selectedDate,
            onDatePicked: (newDateTime) {
              setState(() {
                selectedDate = newDateTime;
              });
            },
          ),
           SizedBox(height: 30.sp),
          CustomTextFormField(
            controller: widget.imageUrlController,
            labelText: 'Image URL',
            icon: Icons.image,
          ),
          SizedBox(height: 60.sp),
          ElevatedButton.icon(
            onPressed: () {
              final url = widget.imageUrlController.text.trim();
              if (url.isNotEmpty) {
                setState(() {
                  widget.imageUrls.add(url);
                  widget.imageUrlController.clear();
                });
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Image URL',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: WebsiteColors.primaryBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.sp),
            ),
          ),
          SizedBox(height: 30.sp),
          if (widget.imageUrls.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Added Images: ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 25.sp,
                    color: WebsiteColors.primaryBlueColor,
                  ),
                ),
                SizedBox(height: 10.sp),
                ...widget.imageUrls.map(
                  (url) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        url,
                        width: 80.sp,
                        height: 100.sp,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                      ),
                      title: Text(url),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() => widget.imageUrls.remove(url));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 40.sp),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 200.sp),
            child: ElevatedButton(
              onPressed:
                  widget.isLoading
                      ? null
                      : () async {
                        await widget.addEvent(
                          context: context,
                          formKey: widget.formKey,
                          nameController: widget.nameController,
                          categoryController: widget.categoryController,
                          descriptionController: widget.descriptionController,
                          locationController: widget.locationController,
                          timeController: widget.timeController,
                          imageUrls: widget.imageUrls,
                          selectedDate: selectedDate,
                          selectedMonth: widget.selectedMonth,
                          isLoading: widget.isLoading,
                          setLoading: widget.setLoading,
                          resetForm: widget.resetForm,
                        );
                      },
              child:
                  widget.isLoading
                      ? const CircularProgressIndicator(
                        color: WebsiteColors.primaryBlueColor,
                      )
                      : Text(
                        'Add Event',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: WebsiteColors.whiteColor,
                          fontSize: 22.sp,
                        ),
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: WebsiteColors.primaryBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12.sp,
                  horizontal: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
