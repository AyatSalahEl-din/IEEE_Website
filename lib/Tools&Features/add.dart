// Example of how to use EventProposalForm in your parent widget
import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Tools&Features/proposal.dart';

class EventProposalScreen extends StatefulWidget {
  const EventProposalScreen({super.key});

  @override
  State<EventProposalScreen> createState() => _EventProposalScreenState();
}

class _EventProposalScreenState extends State<EventProposalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _expectedAttendeesController =
      TextEditingController();
  final TextEditingController _proposedDateController = TextEditingController();
  final TextEditingController _proposedLocationController =
      TextEditingController();
  final TextEditingController _ieeeBenefitsController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _eventNameController.dispose();
    _organizerNameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _eventDescriptionController.dispose();
    _expectedAttendeesController.dispose();
    _proposedDateController.dispose();
    _proposedLocationController.dispose();
    _ieeeBenefitsController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _submitProposal() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Here you would typically send the proposal to your backend
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proposal submitted successfully!')),
        );

        // Clear form after submission
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting proposal: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IEEE Event Proposal'),
        backgroundColor: WebsiteColors.primaryBlueColor,
      ),
      body: EventProposalForm(
        formKey: _formKey,
        eventNameController: _eventNameController,
        organizerNameController: _organizerNameController,
        companyNameController: _companyNameController,
        emailController: _emailController,
        phoneController: _phoneController,
        eventDescriptionController: _eventDescriptionController,
        expectedAttendeesController: _expectedAttendeesController,
        proposedDateController: _proposedDateController,
        proposedLocationController: _proposedLocationController,
        ieeeBenefitsController: _ieeeBenefitsController,
        additionalNotesController: _additionalNotesController,
        submitProposal: _submitProposal,
        isLoading: _isLoading,
      ),
    );
  }
}

// Ensure all sizes have .sp applied
