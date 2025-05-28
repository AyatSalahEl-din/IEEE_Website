import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_website/Tools&Features/custom_text_form_field.dart';
import 'package:ieee_website/Tools&Features/custom_date_picker.dart';

class EventProposalForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController eventNameController;
  final TextEditingController organizerNameController;
  final TextEditingController companyNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController eventDescriptionController;
  final TextEditingController expectedAttendeesController;
  final TextEditingController proposedDateController;
  final TextEditingController proposedLocationController;
  final TextEditingController ieeeBenefitsController;
  final TextEditingController additionalNotesController;
  final Function submitProposal;
  final bool isLoading;

  const EventProposalForm({
    super.key,
    required this.formKey,
    required this.eventNameController,
    required this.organizerNameController,
    required this.companyNameController,
    required this.emailController,
    required this.phoneController,
    required this.eventDescriptionController,
    required this.expectedAttendeesController,
    required this.proposedDateController,
    required this.proposedLocationController,
    required this.ieeeBenefitsController,
    required this.additionalNotesController,
    required this.submitProposal,
    required this.isLoading,
  });

  @override
  State<EventProposalForm> createState() => _EventProposalFormState();
}

class _EventProposalFormState extends State<EventProposalForm> {
  DateTime? selectedDate;
  bool isVirtual = false;
  bool isHybrid = false;

  Future<void> _submitProposal() async {
    if (!widget.formKey.currentState!.validate()) return;

    try {
      final proposalData = {
        'eventName': widget.eventNameController.text.trim(),
        'organizerName': widget.organizerNameController.text.trim(),
        'companyName': widget.companyNameController.text.trim(),
        'email': widget.emailController.text.trim(),
        'phone': widget.phoneController.text.trim(),
        'eventDescription': widget.eventDescriptionController.text.trim(),
        'expectedAttendees': widget.expectedAttendeesController.text.trim(),
        'proposedDate':
            selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
        'proposedLocation':
            isVirtual
                ? 'Online'
                : widget.proposedLocationController.text.trim(),
        'ieeeBenefits': widget.ieeeBenefitsController.text.trim(),
        'additionalNotes': widget.additionalNotesController.text.trim(),
        'isOnlineEvent': isVirtual,
        'status': 'pending',
        'submittedAt': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('event_proposals')
          .add(proposalData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Proposal submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form after submission
      widget.formKey.currentState!.reset();
      widget.eventNameController.clear();
      widget.organizerNameController.clear();
      widget.companyNameController.clear();
      widget.emailController.clear();
      widget.phoneController.clear();
      widget.eventDescriptionController.clear();
      widget.expectedAttendeesController.clear();
      widget.proposedDateController.clear();
      widget.proposedLocationController.clear();
      widget.ieeeBenefitsController.clear();
      widget.additionalNotesController.clear();
      setState(() {
        selectedDate = null;
        isVirtual = false;
        isHybrid = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit proposal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Propose an Event',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
      ),
      body: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Propose an Event',
                  style: TextStyle(
                    color: WebsiteColors.primaryBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width > 600 ? 28.sp : 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.sp),
              Text(
                'Do you want to propose an event to collaborate with IEEE SB PUA? Fill out the form below with your details and event information, and we will get back to you shortly!',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: WebsiteColors.darkBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.sp),
              _buildSectionTitle('Organizer Information'),
              SizedBox(height: 15.sp),
              CustomTextForm(
                controller: widget.organizerNameController,
                labelText: 'Your Full Name',
                icon: Icons.person,
                keyboardType: TextInputType.name,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter your name'
                            : null,
              ),
              SizedBox(height: 20.sp),
              CustomTextForm(
                controller: widget.companyNameController,
                labelText: 'Company/Organization Name',
                icon: Icons.business,
                keyboardType: TextInputType.text,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter company/organization name'
                            : null,
              ),
              SizedBox(height: 20.sp),
              CustomTextForm(
                controller: widget.emailController,
                labelText: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your email';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value))
                    return 'Please enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 20.sp),
              CustomTextForm(
                controller: widget.phoneController,
                labelText: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter your phone number'
                            : null,
              ),
              SizedBox(height: 30.sp),
              Divider(color: WebsiteColors.primaryBlueColor.withOpacity(0.3)),
              SizedBox(height: 20.sp),
              _buildSectionTitle('Event Details'),
              SizedBox(height: 15.sp),
              CustomTextForm(
                controller: widget.eventNameController,
                labelText: 'Event Name',
                icon: Icons.event,
                keyboardType: TextInputType.text,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter event name'
                            : null,
              ),
              SizedBox(height: 20.sp),
              CustomTextForm(
                controller: widget.eventDescriptionController,
                labelText: 'Event Description',
                icon: Icons.description,
                isMultiline: true,
                keyboardType: TextInputType.multiline,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter event description'
                            : null,
              ),
              SizedBox(height: 20.sp),
              Text(
                "Proposed Date",
                style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).size.width > 600 ? 18.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.darkBlueColor,
                ),
              ),
              SizedBox(height: 10.sp),
              CustomDatePicker(
                initialDate: selectedDate,
                onDatePicked: (pickedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                    widget.proposedDateController.text =
                        pickedDate != null
                            ? DateFormat.yMMMd().format(pickedDate)
                            : '';
                  });
                },
              ),
              SizedBox(height: 20.sp),
              Text(
                'Event Format',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.primaryBlueColor,
                ),
              ),
              SizedBox(height: 10.sp),
              Row(
                children: [
                  _buildChoiceChip('In-Person', !isVirtual && !isHybrid, () {
                    setState(() {
                      isVirtual = false;
                      isHybrid = false;
                    });
                  }),
                  SizedBox(width: 10.sp),
                  _buildChoiceChip('Virtual', isVirtual, () {
                    setState(() {
                      isVirtual = true;
                      isHybrid = false;
                    });
                  }),
                  SizedBox(width: 10.sp),
                  _buildChoiceChip('Hybrid', isHybrid, () {
                    setState(() {
                      isHybrid = true;
                      isVirtual = false;
                    });
                  }),
                ],
              ),
              SizedBox(height: 20.sp),
              if (!isVirtual)
                CustomTextForm(
                  controller: widget.proposedLocationController,
                  labelText: 'Proposed Location/Venue',
                  icon: Icons.location_on,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if ((!isVirtual && (value == null || value.isEmpty))) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20.sp),
              CustomTextForm(
                controller: widget.ieeeBenefitsController,
                labelText: 'How will IEEE benefit from this collaboration?',
                icon: Icons.handshake,
                isMultiline: true,
                keyboardType: TextInputType.multiline,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please explain benefits to IEEE'
                            : null,
              ),
              SizedBox(height: 20.sp),
              CustomTextForm(
                controller: widget.additionalNotesController,
                labelText: 'Additional Notes/Requirements',
                icon: Icons.note_add,
                isMultiline: true,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 40.sp),
              Center(
                child: SizedBox(
                  width: 250.sp,
                  child: ElevatedButton(
                    onPressed: widget.isLoading ? null : _submitProposal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebsiteColors.primaryBlueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical:
                            MediaQuery.of(context).size.width > 600
                                ? 15.sp
                                : 12.sp,
                        horizontal: 30.sp,
                      ),
                      elevation: 5,
                    ),
                    child:
                        widget.isLoading
                            ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.sp,
                            )
                            : Text(
                              'Submit Proposal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 18.sp
                                        : 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
              SizedBox(height: 20.sp),
              Center(
                child: Text(
                  'We will review your proposal and contact you within 5 business days',
                  style: TextStyle(
                    color: WebsiteColors.darkBlueColor,
                    fontSize: 14.sp,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: WebsiteColors.primaryBlueColor,
      ),
    );
  }

  Widget _buildChoiceChip(
    String label,
    bool isSelected,
    VoidCallback onSelected,
  ) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 14.sp)),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: WebsiteColors.primaryBlueColor,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : WebsiteColors.primaryBlueColor,
      ),
    );
  }
}
