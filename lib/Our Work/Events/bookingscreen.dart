import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final List<String> events = [
    'IEEE Workshop',
    'Tech Talk Session',
    'IEEE Annual Conference',
    'Networking Event',
    'Coding Competition',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WebsiteColors.whiteColor,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        elevation: 0,
        title: Text(
          'Book Your Seat',
          style: TextStyle(
            color: WebsiteColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: WebsiteColors.whiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: WebsiteColors.primaryBlueColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Reserve Your Spot Today',
                    style: TextStyle(
                      color: WebsiteColors.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Join IEEE PUA Student Branch events and expand your knowledge',
                    style: TextStyle(
                      color: WebsiteColors.whiteColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Booking form
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: 'Personal Information'),
                    SizedBox(height: 15),

                    // Personal Information Fields
                    CustomTextField(
                      label: 'Full Name',
                      fontSize: 24,
                      prefixIcon: Icons.person,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter your name' : null,
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

                    // Event Information
                    SectionTitle(title: 'Event Information'),
                    SizedBox(height: 15),

                    // Event Dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedEvent,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: WebsiteColors.primaryBlueColor,
                          ),
                          dropdownColor:
                              Colors
                                  .white, // Set dropdown menu background to white
                          items:
                              events.map((String event) {
                                return DropdownMenuItem<String>(
                                  value: event,
                                  child: Text(event),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedEvent = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Number of Tickets
                    Row(
                      children: [
                        Text(
                          'Number of Tickets:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: WebsiteColors.darkBlueColor,
                          ),
                        ),
                        Spacer(),
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
                                  fontWeight: FontWeight.bold,
                                  color: WebsiteColors.primaryBlueColor
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

                    // Date & Time Pickers
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: WebsiteColors.primaryBlueColor,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: WebsiteColors.primaryBlueColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          WebsiteColors
                                              .darkGreyColor, // Changed to grey
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: WebsiteColors.primaryBlueColor,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedTime = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: WebsiteColors.primaryBlueColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${selectedTime.format(context)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          WebsiteColors
                                              .darkGreyColor, // Changed to grey
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    CustomTextField(
                      label: 'Special Requests (Optional)',
                      prefixIcon: Icons.note_alt,
                      maxLines: 3,
                      fontSize: 24,
                    ),
                    SizedBox(height: 30),

                    // IEEE Member section
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: WebsiteColors.gradeintBlueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: WebsiteColors.primaryBlueColor,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Are you an IEEE Member?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: WebsiteColors.darkBlueColor,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'IEEE members get priority seating and special discounts.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        WebsiteColors
                                            .darkGreyColor, // Changed to grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    CustomTextField(
                      label: 'IEEE Membership ID (If applicable)',
                      prefixIcon: Icons.card_membership,
                      fontSize: 14,
                    ),
                    SizedBox(height: 40),

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
                            // Booking logic
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                'Event: $selectedEvent\nDate: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}\nTime: ${selectedTime.format(context)}\nTickets: $numberOfTickets',
                style: TextStyle(
                  fontSize: 14,
                  color: WebsiteColors.darkGreyColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'A confirmation email has been sent to your email address.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

// Custom widgets for reusability
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: 60,
            height: 3,
            color: WebsiteColors.primaryYellowColor,
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    required int fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: WebsiteColors.lightGreyColor,
          fontSize: 14, // Smaller font size
          fontWeight: FontWeight.normal, // Normal font weight
        ),
        prefixIcon: Icon(prefixIcon, color: WebsiteColors.primaryBlueColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      style: TextStyle(
        fontSize: 14, // Smaller font size
        fontWeight: FontWeight.normal, // Normal font weight
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
