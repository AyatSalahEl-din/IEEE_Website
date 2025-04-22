import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_website/widgets/bookingwidgets/customdropdown.dart';
import 'package:ieee_website/widgets/bookingwidgets/customtextfield.dart';
import 'package:ieee_website/widgets/bookingwidgets/sectiontitle.dart';
import 'package:ieee_website/widgets/event_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Themes/website_colors.dart';

class EventBookingPage extends StatefulWidget {
  const EventBookingPage({Key? key, TabController? tabController})
    : super(key: key);

  @override
  _EventBookingPageState createState() => _EventBookingPageState();
}

class _EventBookingPageState extends State<EventBookingPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedEventId;
  int numberOfTickets = 1;
  bool busRequired = false;
  String? userType; // Student, Teacher, etc.
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  bool isLoading = true;
  List<Event> upcomingEvents = [];

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents();
  }

  Future<void> fetchUpcomingEvents() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .where(
                'date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()),
              )
              .orderBy('date')
              .get();

      setState(() {
        upcomingEvents =
            snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchEventDetails(String eventId) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();

      if (doc.exists) {
        Event event = Event.fromFirestore(doc);
        setState(() {
          selectedEventId = event.id;
          upcomingEvents = [event]; // Replace with the fetched event
        });
      } else {
        print("Event not found.");
      }
    } catch (e) {
      print("Error fetching event details: $e");
    }
  }

  double calculateTotalPrice(Event event) {
    double total = (event.baseTicketPrice ?? 0) * numberOfTickets;
    if (busRequired && event.busDetails != null) {
      total += event.busDetails!.busTicketPrice * numberOfTickets;
    }
    if (userType == event.discountFor) {
      total -= event.discount ?? 0.0;
    }
    return total;
  }

  Future<void> sendBookingRequest(Event event) async {
    final requestData = {
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'eventName': event.name,
      'requestDate': Timestamp.now(),
      'status': 'pending',
      'busRequired': busRequired,
      'numberOfTickets': numberOfTickets,
      'userType': userType,
    };

    await FirebaseFirestore.instance.collection('requests').add(requestData);
  }

  void sendWhatsAppMessage(Event event) async {
    final totalPrice = calculateTotalPrice(event);

    final message = '''
Hello, I would like to book tickets for the following event:

Event Details:
- Name: ${event.name}
- Date: ${event.date}
- Location: ${event.location}
- Time: ${event.time}

${event.getBusDetails()}
${event.getOnlineEventDetails()}

Booking Details:
- Name: $userName
- Email: $userEmail
- Phone: $userPhone
- Number of Tickets: $numberOfTickets
- Total Price: \$${totalPrice.toStringAsFixed(2)}

${event.getContactDetails()}

Please let me know the preferred payment method to proceed.
''';

    final whatsappUrl = Uri.parse(
      "https://wa.me/${event.contactNumber}?text=${Uri.encodeComponent(message)}",
    );
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  void confirmBooking(Event event) async {
    if (_formKey.currentState!.validate() && selectedEventId != null) {
      final totalPrice = calculateTotalPrice(event);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Booking'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Event Details:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Name: ${event.name}'),
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(event.date)}',
                  ),
                  Text('Location: ${event.location}'),
                  Text('Time: ${event.time}'),
                  Text('Category: ${event.category}'),
                  Text('Description: ${event.details}'),
                  Text('Bus Included: ${busRequired ? "Yes" : "No"}'),
                  Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                  const SizedBox(height: 10),
                  Text(
                    'User Details:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Name: $userName'),
                  Text('Email: $userEmail'),
                  Text('Phone: $userPhone'),
                  const SizedBox(height: 10),
                  Text(
                    'Admin Contact:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Phone: ${event.contactNumber ?? "Not provided"}'),
                  Text('Email: ${event.contactEmail ?? "Not provided"}'),
                  const SizedBox(height: 10),
                  if (event.busDetails != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bus Details:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Departure Location: ${event.busDetails!.departureLocation}',
                        ),
                        Text(
                          'Arrival Location: ${event.busDetails!.arrivalLocation}',
                        ),
                        Text(
                          'Departure Time: ${event.busDetails!.departureTime}',
                        ),
                        Text(
                          'Ticket Price: \$${event.busDetails!.busTicketPrice}',
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  const Text(
                    'Preferred Payment Method:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<String>(
                    items:
                        ['Credit Card', 'PayPal', 'Bank Transfer']
                            .map(
                              (method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      // Handle preferred payment method selection
                    },
                    decoration: const InputDecoration(
                      hintText: 'Select Payment Method',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await sendBookingRequest(event);
                  sendWhatsAppMessage(event);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking request sent successfully!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WebsiteColors.primaryBlueColor,
                ),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WebsiteColors.whiteColor,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        elevation: 0,
        title: const Text(
          'Book Your Tickets',
          style: TextStyle(color: WebsiteColors.whiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WebsiteColors.whiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Personal Information'),
                        const SizedBox(height: 15),
                        CustomTextField(
                          label: 'Full Name',
                          fontSize: 24,
                          prefixIcon: Icons.person,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your name'
                                      : null,
                          onChanged: (value) => userName = value,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          label: 'Email Address',
                          fontSize: 24,
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please enter your email';
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onChanged: (value) => userEmail = value,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          label: 'Phone Number',
                          fontSize: 24,
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your phone number'
                                      : null,
                          onChanged: (value) => userPhone = value,
                        ),
                        const SizedBox(height: 30),
                        const SectionTitle(title: 'Event Information'),
                        const SizedBox(height: 15),
                        CustomDropdown<Event>(
                          hintText: 'Select Event',
                          value:
                              selectedEventId != null
                                  ? upcomingEvents.firstWhere(
                                    (event) => event.id == selectedEventId,
                                  )
                                  : null,
                          items:
                              upcomingEvents.map((Event event) {
                                return DropdownMenuItem<Event>(
                                  value: event,
                                  child: Text(
                                    '${event.name} - ${DateFormat('yyyy-MM-dd').format(event.date)} - ${event.location} - \$${event.baseTicketPrice}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (Event? newValue) {
                            setState(() {
                              selectedEventId = newValue?.id;
                            });
                          },
                        ),
                        if (selectedEventId != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitle(title: 'Event Details'),
                                const SizedBox(height: 10),
                                Text(
                                  '''
Name: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).name}
Date: ${DateFormat('yyyy-MM-dd HH:mm').format(upcomingEvents.firstWhere((event) => event.id == selectedEventId).date)}
Location: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).location}
Time: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).time}
Category: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).category}
Description: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).details}
Discount: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).discount ?? 'None'}
Eligible For Discount: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).discountFor ?? 'None'}
Bus Available: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).busDetails != null ? 'Yes' : 'No'}
Contact Number: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).contactNumber ?? 'Not provided'}
Contact Email: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).contactEmail ?? 'Not provided'}
''',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: WebsiteColors.darkBlueColor,
                                  ),
                                ),
                                if (upcomingEvents
                                        .firstWhere(
                                          (event) =>
                                              event.id == selectedEventId,
                                        )
                                        .busDetails !=
                                    null)
                                  Text(
                                    '''
Bus Details:
- Departure Location: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).busDetails!.departureLocation}
- Arrival Location: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).busDetails!.arrivalLocation}
- Departure Time: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).busDetails!.departureTime}
- Ticket Price: \$${upcomingEvents.firstWhere((event) => event.id == selectedEventId).busDetails!.busTicketPrice}
''',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: WebsiteColors.darkBlueColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Text(
                              "Include Bus Ticket?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: WebsiteColors.greyColor,
                              ),
                            ),
                            Checkbox(
                              value: busRequired,
                              checkColor: WebsiteColors.whiteColor,
                              activeColor: WebsiteColors.primaryBlueColor,
                              onChanged: (value) {
                                setState(() {
                                  busRequired = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomDropdown<String>(
                          hintText: 'Select User Type',
                          value: userType,
                          items:
                              ['Student', 'Teacher', 'Other']
                                  .map(
                                    (type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              userType = value;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                selectedEventId != null) {
                              final selectedEvent = upcomingEvents.firstWhere(
                                (event) => event.id == selectedEventId,
                              );
                              confirmBooking(selectedEvent);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WebsiteColors.primaryBlueColor,
                          ),
                          child: const Text('Confirm Booking'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class EventBookingScreen extends StatelessWidget {
  final Event event;

  EventBookingScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: Colors.blue, // Custom app bar color
      ),
      body: ListView(
        children: [
          // Event Image
          event.imageUrls.isNotEmpty
              ? Image.network(event.imageUrls[0], fit: BoxFit.cover)
              : Container(
                height: 250,
                color: Colors.grey,
              ), // Default grey background if no image

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Details
                Text(
                  event.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "${event.location} - ${DateFormat('yyyy-MM-dd HH:mm').format(event.date)}",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Text(
                  "Category: ${event.category}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  event.details,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 16),

                // Ticket Information
                if (event.isTicketAvailable ?? false) ...[
                  event.isTicketLimited ?? false
                      ? Text(
                        "Limited Tickets Available: ${event.ticketLimit}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                      : Text(
                        "Tickets Available",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                  SizedBox(height: 16),
                  if (event.discount != null)
                    Text(
                      "Discount: ${event.discount}% for ${event.discountFor}",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  SizedBox(height: 16),
                  Text(
                    "Ticket Price: \$${event.baseTicketPrice}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],

                // Online Event Section
                if (event.isOnlineEvent)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "Online Event Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "App: ${event.appName ?? 'Not provided'}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "URL: ${event.appUrl ?? 'Not provided'}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Time: ${event.appTime ?? 'Not provided'}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                // Bus Service Details
                if (event.hasBusService ?? false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "Bus Service Available",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event.getBusDetails(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                // Contact Details
                if (event.contactNumber != null || event.contactEmail != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "Contact Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event.getContactDetails(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                // Booking Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the booking confirmation screen
                      // Or show a dialog to confirm ticket booking
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebsiteColors.primaryBlueColor,
                    ),
                    child: Text(
                      "Book Tickets Now",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
