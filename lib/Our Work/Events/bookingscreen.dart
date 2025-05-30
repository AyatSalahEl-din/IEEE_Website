import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/widgets/event_model.dart';
import 'package:ieee_website/widgets/bookingwidgets/customdropdown.dart';
import 'package:ieee_website/widgets/bookingwidgets/customtextfield.dart';
import 'package:ieee_website/widgets/bookingwidgets/sectiontitle.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventBookingPage extends StatefulWidget {
  const EventBookingPage({Key? key}) : super(key: key);

  @override
  State<EventBookingPage> createState() => _EventBookingPageState();
}

class _EventBookingPageState extends State<EventBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhoneController = TextEditingController();

  String? _selectedEventId;
  int _numberOfTickets = 1;
  int _numberOfBusTickets = 0;
  String? _userType;
  bool _isLoading = true;
  List<Event> _upcomingEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchUpcomingEvents();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchUpcomingEvents() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .where(
                'date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()),
              )
              .orderBy('date')
              .get();

      if (snapshot.docs.isEmpty) {
        _showError('No upcoming events found.');
        print('Debug: No documents found in the "events" collection.');
      } else {
        print('Debug: Fetched ${snapshot.docs.length} events.');
      }

      setState(() {
        _upcomingEvents =
            snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        _isLoading = false;
      });
    } catch (e) {
      _showError('Failed to load events: $e');
      print('Debug: Error fetching events - $e');
      setState(() => _isLoading = false);
    }
  }

  Event? get _selectedEvent {
    if (_selectedEventId == null) return null;
    return _upcomingEvents.firstWhere((event) => event.id == _selectedEventId);
  }

  double get _totalPrice {
    if (_selectedEvent == null) return 0.0;

    final event = _selectedEvent!;
    double total =
        event.isOnlineEvent
            ? 0.0
            : (event.baseTicketPrice ?? 0) * _numberOfTickets;

    // Apply discount if eligible (case-insensitive comparison)
    if (_userType != null &&
        event.discountFor != null &&
        _userType!.toLowerCase() == event.discountFor!.toLowerCase() &&
        event.discount != null) {
      total -= (event.discount! / 100) * total;
    }

    if (!event.isOnlineEvent && event.busDetails != null) {
      total += event.busDetails!.busTicketPrice * _numberOfBusTickets;
    }

    return total.clamp(0.0, double.infinity);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _sendBookingRequest() async {
    if (_selectedEvent == null) return;

    // Ensure all personal details are filled
    if (_userNameController.text.trim().isEmpty ||
        _userEmailController.text.trim().isEmpty ||
        _userPhoneController.text.trim().isEmpty) {
      _showError('Please fill in all personal details (Name, Email, Phone).');
      return;
    }

    try {
      // Generate a unique order number
      final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();

      final bookingData = {
        'orderNumber': orderNumber, // Add order number to the request
        'userName': _userNameController.text.trim(),
        'userEmail': _userEmailController.text.trim(),
        'userPhone': _userPhoneController.text.trim(),
        'eventName': _selectedEvent!.name,
        'requestDate': Timestamp.now(),
        'status': 'pending',
        'busRequired': _numberOfBusTickets > 0,
        'numberOfTickets': _numberOfTickets,
        'userType': _userType,
        'totalPrice': _totalPrice,
      };

      // Save booking details to Firebase
      await FirebaseFirestore.instance.collection('requests').add(bookingData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking request sent successfully! Order Number: $orderNumber',
          ),
        ),
      );

      // Show confirmation dialog with order number
      _showOrderConfirmationDialog(orderNumber);

      // Send WhatsApp message with order number
      _sendWhatsAppMessage(_selectedEvent!, orderNumber);
    } catch (e) {
      _showError('Failed to send booking request: $e');
    }
  }

  Future<void> _sendWhatsAppMessage(Event event, String orderNumber) async {
    final message = '''
Hello, I would like to confirm my booking for the following event:

Event Details:
- Name: ${event.name}
- Date: ${DateFormat('yyyy-MM-dd').format(event.date)}
- Location: ${event.location}
- Time: ${event.time}

Booking Details:
- Order Number: $orderNumber
- Name: ${_userNameController.text}
- Email: ${_userEmailController.text}
- Phone: ${_userPhoneController.text}
- Number of Tickets: $_numberOfTickets
${_numberOfBusTickets > 0 ? '- Bus Tickets: $_numberOfBusTickets\n' : ''}
- Total Price: \$${_totalPrice.toStringAsFixed(2)}

Admin Contact:
- Phone: ${event.contactNumber ?? "Not provided"}
- Email: ${event.contactEmail ?? "Not provided"}

Please let me know the next steps for payment.
''';

    final whatsappUrl = Uri.parse(
      "https://wa.me/${event.contactNumber}?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      _showError('Could not launch WhatsApp');
    }
  }

  void _showOrderConfirmationDialog(String orderNumber) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(
              'Booking Confirmed',
              style: TextStyle(
                color: WebsiteColors.primaryBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Your booking request has been successfully submitted.\n\nOrder Number: $orderNumber\n\nPlease save this order number for future reference.',
              style: TextStyle(
                color: WebsiteColors.darkBlueColor,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: WebsiteColors.primaryBlueColor,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  void _confirmBooking() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEvent == null) {
      _showError('Please select an event');
      return;
    }

    final event = _selectedEvent!;
    if (event.isOnlineEvent) {
      _confirmOnlineAttendance(event);
    } else {
      _confirmTicketBooking(event);
    }
  }

  void _confirmOnlineAttendance(Event event) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(
              'Confirm Attendance',
              style: TextStyle(
                color: WebsiteColors.primaryBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'You are about to confirm your attendance for the online event "${event.name}".\n\n'
              'App: ${event.appName ?? "Not provided"}\n'
              'URL: ${event.appUrl ?? "Not provided"}\n'
              'Time: ${event.appTime ?? "Not provided"}',
              style: TextStyle(
                color: WebsiteColors.darkBlueColor,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: WebsiteColors.primaryBlueColor,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendAttendanceConfirmation(event);
                },
                style: TextButton.styleFrom(
                  foregroundColor: WebsiteColors.primaryBlueColor,
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  TextStyle defaultTextStyle = TextStyle(fontSize: 16);

  void _confirmTicketBooking(Event event) {
    if (!_formKey.currentState!.validate()) {
      _showError('Please fill in all required fields.');
      return;
    }

    if (_userNameController.text.trim().isEmpty ||
        _userEmailController.text.trim().isEmpty ||
        _userPhoneController.text.trim().isEmpty) {
      _showError(
        'Please fill in all personal details before confirming the booking.',
      );
      return;
    }

    final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Confirm Booking',
              style: TextStyle(
                color: WebsiteColors.primaryBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: 16, // Updated font size
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Event Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                      fontSize: 16, // Updated font size
                    ),
                  ),
                  Text(
                    'Name: ${event.name}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(event.date)}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  Text(
                    'Location: ${event.location}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  Text(
                    'Time: ${event.time}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Personal Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                      fontSize: 16, // Updated font size
                    ),
                  ),
                  Text(
                    'Name: ${_userNameController.text.trim()}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  Text(
                    'Email: ${_userEmailController.text.trim()}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  Text(
                    'Phone: ${_userPhoneController.text.trim()}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Booking Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                      fontSize: 16, // Updated font size
                    ),
                  ),
                  Text(
                    'Order Number: $orderNumber',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  Text(
                    'Number of Tickets: $_numberOfTickets',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  if (_numberOfBusTickets > 0)
                    Text(
                      'Bus Tickets: $_numberOfBusTickets',
                      style: defaultTextStyle.copyWith(
                        color: WebsiteColors.primaryBlueColor,
                      ),
                    ),
                  Text(
                    'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Admin Contact:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                      fontSize: 16, // Updated font size
                    ),
                  ),
                  Text(
                    'Phone: ${event.contactNumber ?? "Not provided"}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                  Text(
                    'Email: ${event.contactEmail ?? "Not provided"}',
                    style: defaultTextStyle.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: WebsiteColors.primaryBlueColor,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Updated font size
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendBookingRequest();
                },
                style: TextButton.styleFrom(
                  foregroundColor: WebsiteColors.primaryBlueColor,
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Updated font size
                  ),
                ),
              ),
            ],
          ),
    );
  }


  Future<void> _sendAttendanceConfirmation(Event event) async {
    try {
      await FirebaseFirestore.instance.collection('attendance').add({
        'userName': _userNameController.text,
        'userEmail': _userEmailController.text,
        'userPhone': _userPhoneController.text,
        'eventName': event.name,
        'confirmationDate': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance confirmed successfully!')),
      );
    } catch (e) {
      _showError('Failed to confirm attendance: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        elevation: 0,
        title: const Text(
          'Book Your Tickets',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Personal Information',
                        fontSize: 16,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        fontSize: 16,
                        controller:
                            _userNameController, // Ensure the controller is passed
                        label: 'Full Name',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller:
                            _userEmailController, // Ensure the controller is passed
                        label: 'Email Address',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        fontSize: 16,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller:
                            _userPhoneController, // Ensure the controller is passed
                        label:
                            'Phone Number (used on WhatsApp)', // Updated label
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        fontSize: 16,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number used on WhatsApp';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const SectionTitle(
                        title: 'Event Information',
                        fontSize: 16,
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<Event>(
                        hintText: 'Select Event',
                        value: _selectedEvent,
                        items:
                            _upcomingEvents.map((event) {
                              return DropdownMenuItem<Event>(
                                value: event,
                                child: Text(
                                  '${event.name} - ${DateFormat('MMM d').format(event.date)}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: WebsiteColors.primaryBlueColor,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (event) {
                          setState(() {
                            _selectedEventId = event?.id;
                            _numberOfBusTickets = 0;
                            _userType = null;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Please select an event' : null,
                      ),
                      if (_selectedEvent != null) ...[
                        const SizedBox(height: 24),
                        _buildEventDetailsSection(),
                        const SizedBox(height: 24),
                        _buildTicketSelectionSection(),
                        const SizedBox(height: 24),
                        _buildTotalPriceSection(),
                        const SizedBox(height: 24),
                        _buildBookButton(),
                      ],
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildEventDetailsSection() {
    final event = _selectedEvent!;
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event Details:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WebsiteColors.darkBlueColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Name: ${event.name}',
              style: const TextStyle(
                color: WebsiteColors.darkBlueColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('EEE, MMM d, y').format(event.date)}',
              style: const TextStyle(
                color: WebsiteColors.darkBlueColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${event.time}',
              style: const TextStyle(
                color: WebsiteColors.darkBlueColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${event.location}',
              style: const TextStyle(
                color: WebsiteColors.darkBlueColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            if (event.isOnlineEvent) ...[
              const Text(
                'This is an online event.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'App: ${event.appName ?? "Not provided"}',
                style: const TextStyle(
                  color: WebsiteColors.darkBlueColor,
                  fontSize: 16,
                ),
              ),
              Text(
                'URL: ${event.appUrl ?? "Not provided"}',
                style: const TextStyle(
                  color: WebsiteColors.darkBlueColor,
                  fontSize: 16,
                ),
              ),
              Text(
                'Time: ${event.appTime ?? "Not provided"}',
                style: const TextStyle(
                  color: WebsiteColors.darkBlueColor,
                  fontSize: 16,
                ),
              ),
            ] else ...[
              Text(
                'Price: \$${event.baseTicketPrice?.toStringAsFixed(2) ?? 'Free'}',
                style: const TextStyle(
                  color: WebsiteColors.darkBlueColor,
                  fontSize: 16,
                ),
              ),
              if (event.discount != null && event.discountFor != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Discount: ${event.discount}% for ${event.discountFor}',
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
              if (event.busDetails != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Bus available: \$${event.busDetails!.busTicketPrice.toStringAsFixed(2)} per ticket',
                  style: const TextStyle(
                    color: WebsiteColors.darkBlueColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketSelectionSection() {
    final event = _selectedEvent!;
    if (event.isOnlineEvent) {
      return const Text(
        'No tickets required for online events. Confirm your attendance below.',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: WebsiteColors.primaryBlueColor,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Ticket Options', fontSize: 16),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Number of Tickets:',
              style: TextStyle(
                color: WebsiteColors.primaryBlueColor,
                fontSize: 16,
              ),
            ),
            DropdownButton<int>(
              value: _numberOfTickets,
              items:
                  List.generate(10, (index) => index + 1)
                      .map(
                        (num) => DropdownMenuItem<int>(
                          value: num,
                          child: Text(
                            num.toString(),
                            style: const TextStyle(
                              color: WebsiteColors.primaryBlueColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _numberOfTickets = value!;
                  if (_numberOfBusTickets > _numberOfTickets) {
                    _numberOfBusTickets = _numberOfTickets;
                  }
                });
              },
              dropdownColor: Colors.white, // Set dropdown background to white
            ),
          ],
        ),
        if (event.discountFor != null) ...[
          const SizedBox(height: 16),
          Text(
            'See if you are  applicable for a discount?:',
            style: TextStyle(
              color: WebsiteColors.primaryBlueColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown<String>(
            hintText:
                'Please select your category (e.g., Student, Teacher, Other)',
            value: _userType,
            items:
                ['Students', 'Teachers', 'Others']
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: WebsiteColors.primaryBlueColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _userType = value),
            validator:
                (value) => value == null ? 'Please select your category' : null,
          ),
        ],
        if (event.busDetails != null) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bus Tickets:',
                style: TextStyle(
                  color: WebsiteColors.primaryBlueColor,
                  fontSize: 16,
                ),
              ),
              DropdownButton<int>(
                value: _numberOfBusTickets,
                items:
                    List.generate(_numberOfTickets + 1, (index) => index)
                        .map(
                          (num) => DropdownMenuItem<int>(
                            value: num,
                            child: Text(
                              num.toString(),
                              style: const TextStyle(
                                color: WebsiteColors.primaryBlueColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => _numberOfBusTickets = value!),
                dropdownColor: Colors.white, // Set dropdown background to white
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTotalPriceSection() {
    if (_selectedEvent?.isOnlineEvent ?? false) {
      return const Text(
        'No payment required for online events.',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      );
    }

    return Card(
      color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Price:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WebsiteColors.darkBlueColor,
              ),
            ),
            Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WebsiteColors.primaryBlueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _confirmBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: WebsiteColors.primaryBlueColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Book Now',
          style: TextStyle(
            fontSize: 16,
            color: WebsiteColors.primaryBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
