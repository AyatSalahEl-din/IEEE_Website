// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ieee_website/firebase_options.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final analyticsService = AnalyticsService();
  await analyticsService.initialize();
  
  runApp(EventProposalApp(analyticsService: analyticsService));
}

class EventProposalApp extends StatelessWidget {
  final AnalyticsService analyticsService;
  
  const EventProposalApp({Key? key, required this.analyticsService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Proposal System',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      routes: {
        '/': (context) => const EventProposalScreen(),
      },
      navigatorObservers: [
        analyticsService.getAnalyticsObserver(),
      ],
    );
  }
}


class AppTheme {
  static const Color primaryColor = Color(0xFF00629B); // IEEE blue
  
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor.withOpacity(0.7),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
      ),
    );
  }
}

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Event Proposal System',
      'basicInfo': 'Basic Information',
      'organizerDetails': 'Organizer Details',
      'eventLogistics': 'Event Logistics',
      'review': 'Review & Submit',
      'title': 'Event Title',
      'description': 'Description',
      'email': 'Email Address',
      'date': 'Proposed Date',
      'audience': 'Target Audience',
      'supportingDocs': 'Supporting Documents',
      'next': 'Next',
      'previous': 'Previous',
      'submit': 'Submit Proposal',
      'uploadFile': 'Upload File',
      'addAudience': 'Add Audience Type',
      'enterAudience': 'Enter audience type',
      'confirmation': 'Confirmation',
      'confirmSubmit': 'Are you sure you want to submit this proposal?',
      'yes': 'Yes',
      'no': 'No',
      'success': 'Success',
      'proposalSubmitted': 'Your proposal has been submitted successfully!',
      'error': 'Error',
      'genericError': 'Something went wrong. Please try again.',
      'requiredField': 'This field is required',
      'invalidEmail': 'Please enter a valid email address',
      'invalidDate': 'Please select a future date',
    },
    'ar': {
      'appTitle': 'نظام اقتراح الفعاليات',
      'basicInfo': 'المعلومات الأساسية',
      'organizerDetails': 'تفاصيل المنظم',
      'eventLogistics': 'تفاصيل الفعالية',
      'review': 'المراجعة والتقديم',
      'title': 'عنوان الفعالية',
      'description': 'الوصف',
      'email': 'البريد الإلكتروني',
      'date': 'التاريخ المقترح',
      'audience': 'الجمهور المستهدف',
      'supportingDocs': 'المستندات الداعمة',
      'next': 'التالي',
      'previous': 'السابق',
      'submit': 'تقديم المقترح',
      'uploadFile': 'رفع ملف',
      'addAudience': 'إضافة نوع جمهور',
      'enterAudience': 'أدخل نوع الجمهور',
      'confirmation': 'تأكيد',
      'confirmSubmit': 'هل أنت متأكد من تقديم هذا المقترح؟',
      'yes': 'نعم',
      'no': 'لا',
      'success': 'نجاح',
      'proposalSubmitted': 'تم تقديم مقترحك بنجاح!',
      'error': 'خطأ',
      'genericError': 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
      'requiredField': 'هذا الحقل مطلوب',
      'invalidEmail': 'يرجى إدخال بريد إلكتروني صالح',
      'invalidDate': 'يرجى اختيار تاريخ مستقبلي',
    },
  };
  
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class EventProposal {
  final String title;
  final String description;
  final String organizerEmail;
  final DateTime proposedDate;
  final List<String> targetAudience;
  final List<String> supportingDocs;
  
  EventProposal({
    required this.title,
    required this.description,
    required this.organizerEmail,
    required this.proposedDate,
    required this.targetAudience,
    required this.supportingDocs,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'organizerEmail': organizerEmail,
      'proposedDate': Timestamp.fromDate(proposedDate),
      'targetAudience': targetAudience,
      'supportingDocs': supportingDocs,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    };
  }
  
  factory EventProposal.fromMap(Map<String, dynamic> map) {
    return EventProposal(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      organizerEmail: map['organizerEmail'] ?? '',
      proposedDate: (map['proposedDate'] as Timestamp).toDate(),
      targetAudience: List<String>.from(map['targetAudience'] ?? []),
      supportingDocs: List<String>.from(map['supportingDocs'] ?? []),
    );
  }
}



class ProposalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AnalyticsService _analyticsService;
  final Uuid _uuid = const Uuid();
  
  ProposalService(this._analyticsService);
  
  Future<String> uploadFile(File file, String email) async {
    try {
      final String fileName = '${_uuid.v4()}_${file.path.split('/').last}';
      final Reference ref = _storage.ref().child('proposals/$email/$fileName');
      
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }
  
  Future<void> submitProposal(EventProposal proposal) async {
    try {
      await _firestore.collection('event_proposals').add(proposal.toMap());
      
      _analyticsService.logEvent(
        'proposal_submitted',
        parameters: {
          'organizer_email': proposal.organizerEmail,
          'has_supporting_docs': proposal.supportingDocs.isNotEmpty,
        },
      );
    } catch (e) {
      _analyticsService.logEvent('proposal_submission_error', parameters: {'error': e.toString()});
      throw Exception('Proposal submission failed: $e');
    }
  }
}



class AnalyticsService {
  late FirebaseAnalytics _analytics;
  
  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
  }
  
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    _analytics.logEvent(name: name, parameters: parameters as Map<String, Object>?);
  }
  
  NavigatorObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }
}

// lib/screens/event_proposal_screen.dart

class EventProposalScreen extends StatefulWidget {
  const EventProposalScreen({Key? key}) : super(key: key);

  @override
  State<EventProposalScreen> createState() => _EventProposalScreenState();
}

class _EventProposalScreenState extends State<EventProposalScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  late TextEditingController _audienceController;
  DateTime? _selectedDate;
  final List<String> _targetAudience = [];
  final List<File> _selectedFiles = [];
  final List<String> _uploadedFileUrls = [];
  late ProposalService _proposalService;
  late AnalyticsService _analyticsService;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _emailController = TextEditingController();
    _audienceController = TextEditingController();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    _proposalService = ProposalService(_analyticsService);
    
    _analyticsService.logEvent('proposal_form_viewed');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _audienceController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            if (file.path != null) {
              _selectedFiles.add(File(file.path!));
            }
          }
        });
        
        _analyticsService.logEvent(
          'files_selected',
          parameters: {'count': result.files.length},
        );
      }
    } catch (e) {
      _showErrorDialog('Error selecting files: $e');
    }
  }

  void _addAudience() {
    final audience = _audienceController.text.trim();
    if (audience.isNotEmpty && !_targetAudience.contains(audience)) {
      setState(() {
        _targetAudience.add(audience);
        _audienceController.clear();
      });
    }
  }

  void _removeAudience(String audience) {
    setState(() {
      _targetAudience.remove(audience);
    });
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      
      _analyticsService.logEvent('date_selected');
    }
  }

  Future<void> _submitProposal() async {
    final localizations = AppLocalizations.of(context);
    
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('confirmation')),
        content: Text(localizations.translate('confirmSubmit')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.translate('no')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations.translate('yes')),
          ),
        ],
      ),
    ) ?? false;
    
    if (!confirm) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Upload files
      for (var file in _selectedFiles) {
        final url = await _proposalService.uploadFile(file, _emailController.text);
        _uploadedFileUrls.add(url);
      }
      
      // Create and submit proposal
      final proposal = EventProposal(
        title: _titleController.text,
        description: _descriptionController.text,
        organizerEmail: _emailController.text,
        proposedDate: _selectedDate!,
        targetAudience: _targetAudience,
        supportingDocs: _uploadedFileUrls,
      );
      
      await _proposalService.submitProposal(proposal);
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('proposalSubmitted'))),
        );
        
        // Reset form
        _titleController.clear();
        _descriptionController.clear();
        _emailController.clear();
        _audienceController.clear();
        setState(() {
          _currentStep = 0;
          _selectedDate = null;
          _targetAudience.clear();
          _selectedFiles.clear();
          _uploadedFileUrls.clear();
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('ok')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);    
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('appTitle')),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Form(
          key: _formKey,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 3) {
                setState(() {
                  _currentStep++;
                });
                
                _analyticsService.logEvent(
                  'proposal_step_completed',
                  parameters: {'step': _currentStep},
                );
              } else {
                _submitProposal();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: Text(localizations.translate('previous')),
                        ),
                      ),
                    if (_currentStep > 0)
                      const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(
                          _currentStep == 3
                              ? localizations.translate('submit')
                              : localizations.translate('next'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text(localizations.translate('basicInfo')),
                content: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: localizations.translate('title'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.translate('requiredField');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: localizations.translate('description'),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.translate('requiredField');
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
              ),
              Step(
                title: Text(localizations.translate('organizerDetails')),
                content: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: localizations.translate('email'),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.translate('requiredField');
                        }
                        final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegExp.hasMatch(value)) {
                          return localizations.translate('invalidEmail');
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                isActive: _currentStep >= 1,
              ),
              Step(
                title: Text(localizations.translate('eventLogistics')),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? localizations.translate('date')
                                  : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedDate == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                        child: Text(
                          localizations.translate('requiredField'),
                          style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.translate('audience'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _audienceController,
                            decoration: InputDecoration(
                              hintText: localizations.translate('enterAudience'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addAudience,
                          child: Text(localizations.translate('addAudience')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _targetAudience.map((audience) => Chip(
                        label: Text(audience),
                        onDeleted: () => _removeAudience(audience),
                      )).toList(),
                    ),
                    if (_targetAudience.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                        child: Text(
                          localizations.translate('requiredField'),
                          style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                isActive: _currentStep >= 2,
              ),
              Step(
                title: Text(localizations.translate('review')),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReviewSection(
                      localizations.translate('title'),
                      _titleController.text,
                    ),
                    _buildReviewSection(
                      localizations.translate('description'),
                      _descriptionController.text,
                    ),
                    _buildReviewSection(
                      localizations.translate('email'),
                      _emailController.text,
                    ),
                    _buildReviewSection(
                      localizations.translate('date'),
                      _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                    ),
                    _buildReviewSection(
                      localizations.translate('audience'),
                      _targetAudience.join(', '),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.translate('supportingDocs'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickFiles,
                      icon: const Icon(Icons.upload_file),
                      label: Text(localizations.translate('uploadFile')),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedFiles.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _selectedFiles.map((file) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(file.path.split('/').last),
                        )).toList(),
                      ),
                  ],
                ),
                isActive: _currentStep >= 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}

