import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_website/widgets/bookingwidgets/customdropdown.dart';
import 'package:ieee_website/widgets/bookingwidgets/customtextfield.dart';
import 'package:ieee_website/widgets/bookingwidgets/sectiontitle.dart';
import '../../Themes/website_colors.dart';

class EventBookingPage extends StatefulWidget {
  final TabController? tabController;

  const EventBookingPage({Key? key, this.tabController}) : super(key: key);

  @override
  _EventBookingPageState createState() => _EventBookingPageState();
}

class _EventBookingPageState extends State<EventBookingPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedEventId;
  int numberOfTickets = 1;
  bool busRequired = false;
  String? selectedBusStop;
  String? selectedBusTime;

  String userName = '';
  String userEmail = '';
  String userPhone = '';

  List<Event> upcomingEvents = [];
  bool isLoading = true;

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
              .where('isPastEvent', isEqualTo: false)
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

  double calculateTotalPrice(Event event) {
    double total = event.baseTicketPrice * numberOfTickets;
    if (busRequired && event.busDetails != null) {
      total += event.busDetails!.busTicketPrice * numberOfTickets;
    }
    return total;
  }

  void _showBookingConfirmation(Event event) {
    double totalPrice = calculateTotalPrice(event);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: WebsiteColors.whiteColor,
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: WebsiteColors.primaryBlueColor,
                size: 60,
              ),
              SizedBox(height: 15),
              Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: WebsiteColors.darkBlueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thank you for booking with IEEE PUA Student Branch.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Event: ${event.name}\n'
                'Date: ${event.date}\n'
                'Location: ${event.location}\n'
                'Tickets: $numberOfTickets\n'
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: WebsiteColors.darkGreyColor,
                ),
              ),
              if (busRequired && event.busDetails != null) ...[
                SizedBox(height: 10),
                Text(
                  'Bus Details:\n'
                  'Departure Location: ${event.busDetails!.departureLocation}\n'
                  'Arrival Location: ${event.busDetails!.arrivalLocation}\n'
                  'Trip Program: ${event.busDetails!.tripProgram}\n'
                  'Departure Time: ${event.busDetails!.departureTime}\n'
                  'Seat Selection: ${event.busDetails!.enableSeatSelection ? "Available" : "Not Available"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: WebsiteColors.primaryBlueColor,
                  ),
                ),
              ],
              SizedBox(height: 10),
              Text(
                'Contact Info:\n'
                'Email: $userEmail\n'
                'Phone: $userPhone',
                style: TextStyle(
                  fontSize: 14,
                  color: WebsiteColors.darkGreyColor,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: WebsiteColors.primaryBlueColor,
                  fontWeight: FontWeight.bold,
                ),
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
      backgroundColor: WebsiteColors.whiteColor,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        elevation: 0,
        title: Text(
          'Book Your Tickets',
          style: TextStyle(
            color: WebsiteColors.whiteColor,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: WebsiteColors.whiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(title: 'Personal Information'),
                        SizedBox(height: 15),
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
                        SizedBox(height: 15),
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
                        SizedBox(height: 15),
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
                        SizedBox(height: 30),
                        SectionTitle(title: 'Event Information'),
                        SizedBox(height: 15),
                        CustomDropdown<Event>(
                          hintText: 'Select Event',
                          value:
                              selectedEventId != null
                                  ? upcomingEvents.firstWhere(
                                    (event) => event.id == selectedEventId,
                                    orElse: () => Event(
                                      id: '',
                                      name: 'Unknown Event',
                                      date: DateTime.now(),
                                      location: 'Unknown Location',
                                      baseTicketPrice: 0.0,
                                    ),
                                  )
                                  : null,
                          items:
                              upcomingEvents.map((Event event) {
                                return DropdownMenuItem<Event>(
                                  value: event,
                                  child: Text(
                                    '${event.name} - ${event.date.toLocal()} - ${event.location} - \$${event.baseTicketPrice}',
                                    style: TextStyle(
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
                            child: Text(
                              'Date: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).date.toLocal()}\n'
                              'Location: ${upcomingEvents.firstWhere((event) => event.id == selectedEventId).location}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              "Include Bus Ticket?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: WebsiteColors.darkBlueColor,
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
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                selectedEventId != null) {
                              Event selectedEvent = upcomingEvents.firstWhere(
                                (event) => event.id == selectedEventId,
                              );
                              _showBookingConfirmation(selectedEvent);
                            }
                          },
                          child: Text('Confirm Booking'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final double baseTicketPrice;
  final BusDetails? busDetails;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.baseTicketPrice,
    this.busDetails,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      baseTicketPrice: (data['baseTicketPrice'] ?? 0).toDouble(),
      busDetails:
          data['busDetails'] != null
              ? BusDetails.fromMap(data['busDetails'])
              : null,
    );
  }
}

class BusDetails {
  final String departureLocation;
  final String arrivalLocation;
  final String tripProgram;
  final String departureTime;
  final double busTicketPrice;
  final bool enableSeatSelection;

  BusDetails({
    required this.departureLocation,
    required this.arrivalLocation,
    required this.tripProgram,
    required this.departureTime,
    required this.busTicketPrice,
    required this.enableSeatSelection,
  });

  factory BusDetails.fromMap(Map<String, dynamic> data) {
    return BusDetails(
      departureLocation: data['departureLocation'] ?? '',
      arrivalLocation: data['arrivalLocation'] ?? '',
      tripProgram: data['tripProgram'] ?? '',
      departureTime: data['departureTime'] ?? '',
      busTicketPrice: (data['busTicketPrice'] ?? 0).toDouble(),
      enableSeatSelection: data['enableSeatSelection'] ?? false,
    );
  }
}
