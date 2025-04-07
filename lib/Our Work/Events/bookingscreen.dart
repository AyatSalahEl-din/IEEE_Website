import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String selectedEvent = 'IEEE Workshop';
  int numberOfTickets = 1;
  bool busRequired = false; // Bus reservation status
  double busFee = 100.0; // Fixed bus fee
  String? selectedBusStop;
  String? selectedBusTime;

  final List<String> busStops = [
    'Stop 1 - Main Street',
    'Stop 2 - High School',
    'Stop 3 - Community Center',
  ];
  
  final List<String> busTimes = ['8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM'];

   final List<Event> events = [
    Event('IEEE Workshop', '15/10/2023', '10:00 AM', 'Main Hall', 30.0),
    Event('Tech Talk Session', '18/10/2023', '11:00 AM', 'Room A', 20.0),
    Event('IEEE Annual Conference', '22/10/2023', '09:00 AM', 'Conference Center', 50.0),
    Event('Networking Event', '25/10/2023', '12:00 PM', 'Open Area', 25.0),
    Event('Coding Competition', '01/11/2023', '01:00 PM', 'Lab 3', 15.0),
  ];

  double getTotalPrice() {
    return (events.firstWhere((event) => event.title == selectedEvent).price *
            numberOfTickets) +
        (busRequired ? busFee * numberOfTickets : 0.0);
  } 


  @override
  Widget build(BuildContext context) {
    final eventDetails = events.firstWhere((event) => event.title == selectedEvent);
    // Calculate Total Price
     double ticketPrice = eventDetails.price;

    double totalPrice =
        (ticketPrice * numberOfTickets) +
        (busRequired ? busFee * numberOfTickets : 0.0);

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
      body: SingleChildScrollView(
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
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                ),
                SizedBox(height: 15),
                CustomTextField(
                  label: 'Email Address',
                  fontSize: 24,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your email';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                CustomTextField(
                  label: 'Phone Number',
                  fontSize: 24,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? 'Please enter your phone number'
                              : null,
                ),
                SizedBox(height: 30),
                SectionTitle(title: 'Event Information'),
                SizedBox(height: 15),

                
                // Event Dropdown with full details

                  CustomDropdown<Event>(
                  hintText: 'Select Event',
                  value: eventDetails,
                  items: events.map((Event event) {
                    return DropdownMenuItem<Event>(
                      value: event,
                      child: Text(
                        '${event.title} - ${event.date} - ${event.time} - ${event.location} - \$${event.price}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                  onChanged: (Event? newValue) {
                    setState(() {
                      selectedEvent = newValue!.title;
                    });
                  },
                ),
                // Display Event Details

                 Text(
                  'Date: ${eventDetails.date}\n'
                  'Time: ${eventDetails.time}\n'
                  'Location: ${eventDetails.location}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                // Bus reservation checkbox
                Row(
                  children: [
                    Text("Include Bus Ticket?", style: TextStyle(
                      fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,)),
                    Checkbox(
                      value: busRequired,
                      checkColor: WebsiteColors.whiteColor,
                      activeColor: WebsiteColors.primaryBlueColor,
                      onChanged: (value) {
                        setState(() {
                          busRequired = value!;
                          if (!busRequired) {
                            selectedBusStop = null;
                            selectedBusTime = null;
                          } // Reset when bus reservation is unchecked
                        });
                      },
                    ),
                    Text('Include Bus Ticket (\$${busFee.toStringAsFixed(2)})', style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),

                // Bus Stop Dropdown
                if (busRequired) ...[
                  SizedBox(height: 15),
                  CustomDropdown<String>(
                    hintText: "Select Nearest Bus Stop",
                    value: selectedBusStop,
                    items: busStops.map((String busStop) {
                      return DropdownMenuItem<String>(
                        value: busStop,
                        child: Text(busStop),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBusStop = newValue;
                      });
                    },
                  ),
                ],

                // Bus Arrival Time Dropdown
                if (busRequired) ...[
                  SizedBox(height: 15),
                  CustomDropdown<String>(
                    hintText: "Select Arrival Time",
                    value: selectedBusTime,
                    items: busTimes.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBusTime = newValue;
                      });
                    },
                  ),
                ],

                SizedBox(height: 15),
                // Number of Tickets
                Row(
                  children: [
                    Text(
                      'Number of Tickets:     ',
                      style: TextStyle(
                        fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
                      ),
                    ),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: WebsiteColors.primaryBlueColor,
                            ),
                            onPressed: () {
                              if (numberOfTickets > 1) {
                                setState(() {
                                  numberOfTickets--;
                                });
                              }
                            },
                          ),
                          Text(
                            '$numberOfTickets',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color:WebsiteColors.primaryBlueColor
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: WebsiteColors.primaryBlueColor,
                            ),
                            onPressed: () {
                              setState(() {
                                numberOfTickets++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Total Price Calculation
                Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize:24,
                    fontWeight: FontWeight.bold,
                    color: WebsiteColors.primaryBlueColor
                  ),
                ),
                SizedBox(height: 30),

                // Submit Button
                Container(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebsiteColors.primaryYellowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showBookingConfirmation();
                      }
                    },
                    child: Text(
                      'Confirm Booking',
                      style: TextStyle(
                        color: WebsiteColors.darkBlueColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
          ]),),
        ),
      ),
    );
  }
void _showBookingConfirmation() {
 double totalPrice = getTotalPrice();
    final eventDetails = events.firstWhere((event) => event.title == selectedEvent);
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
            Text('Event: ${eventDetails.title}\n'
                   'Date: ${eventDetails.date}\n'
                   'Time: ${eventDetails.time}\n'
                   'Location: ${eventDetails.location}\n'
                   'Tickets: $numberOfTickets\n'
                   'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                   style: TextStyle(fontSize: 14, color: WebsiteColors.darkGreyColor)),
              if (busRequired) ...[
              SizedBox(height: 10),
              Text(
                'Pickup Location: $selectedBusStop',
                style: TextStyle(fontSize: 14, color: WebsiteColors.primaryBlueColor),
              ),
              SizedBox(height: 5),
              Text(
                'Pickup Time: $selectedBusTime',
                style: TextStyle(fontSize: 14, color: WebsiteColors.primaryBlueColor),
              ),
            ],
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
}

// Data model for the event
class Event {
  final String title;
  final String date; // Using String for date, adjust to DateTime as needed
  final String time; // Time as String for simplicity
  final String location; // Location as String
  final double price;

  Event(this.title, this.date, this.time, this.location, this.price);
}