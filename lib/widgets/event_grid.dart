import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/widgets/events_card.dart';
import 'package:ieee_website/widgets/event_model.dart';

class EventsGrid extends StatefulWidget {
  final String filterType; // "upcoming" or "previous"

  EventsGrid({super.key, required this.filterType});

  @override
  _EventsGridState createState() => _EventsGridState();

}

class _EventsGridState extends State<EventsGrid> {
  int displayedEventCount = 6; // Start with 6 events
  final int increment = 3; // Show 3 more each time "See More" is clicked
  void initState() {
    super.initState();
    addMultipleEvents();
   // print("list of events added to firestore successfully");// Automatically adds events when the widget loads
  }
  // Sample list of events to test untill adding real data in firebase

  final List<Event> allEvents = [
    // 🔹 9 PAST EVENTS (Before March 6, 2025)
    Event(
      id: '1',
      name: "AI Conference",
      date: "2024-12-15",
      location: "Cairo",
      imageUrl: "assets/images/event1.jpg",
      month: "December",
      time: "2PM",
      category: "AI",
      details: "A deep dive into AI advancements.",
      hostedBy: "Tech Association",
      hostName: "Dr. Ahmed Ali",
    ),
    Event(
      id: '2',
      name: "Blockchain Expo",
      date: "2024-11-20",
      location: "Dubai",
      imageUrl: "assets/images/event2.jpg",
      month: "November",
      time: "1PM",
      category: "Finance",
      details: "Exploring the future of Blockchain.",
      hostedBy: "Crypto Leaders",
      hostName: "Sarah Johnson",
    ),
    Event(
      id: '3',
      name: "Cybersecurity Forum",
      date: "2024-10-10",
      location: "New York",
      imageUrl: "assets/images/event3.jpg",
      month: "October",
      time: "3PM",
      category: "Security",
      details: "The latest in cybersecurity defenses.",
      hostedBy: "CyberSec Global",
      hostName: "John Doe",
    ),
    Event(
      id: '4',
      name: "Startup Pitch Competition",
      date: "2024-09-25",
      location: "Berlin",
      imageUrl: "assets/images/event4.png",
      month: "September",
      time: "11AM",
      category: "Entrepreneurship",
      details: "Where startups compete for funding.",
      hostedBy: "Startup Hub",
      hostName: "Lisa Brown",
    ),
    Event(
      id: '5',
      name: "Robotics Meetup",
      date: "2024-08-12",
      location: "Tokyo",
      imageUrl: "assets/images/event5.png",
      month: "August",
      time: "4PM",
      category: "Robotics",
      details: "Latest trends in robotics and automation.",
      hostedBy: "Robo Innovators",
      hostName: "Ken Tanaka",
    ),
    Event(
      id: '6',
      name: "Space Exploration Talk",
      date: "2024-07-14",
      location: "Houston",
      imageUrl: "assets/images/event6.png",
      month: "July",
      time: "9AM",
      category: "Science",
      details: "The future of interstellar travel.",
      hostedBy: "NASA Experts",
      hostName: "Emily Clarke",
    ),
    Event(
      id: '7',
      name: "Green Energy Conference",
      date: "2024-06-22",
      location: "London",
      imageUrl: "assets/images/event7.png",
      month: "June",
      time: "10AM",
      category: "Environment",
      details: "Renewable energy innovations.",
      hostedBy: "Eco Power",
      hostName: "Michael Green",
    ),
    Event(
      id: '8',
      name: "Mobile App Development Summit",
      date: "2024-05-18",
      location: "San Francisco",
      imageUrl: "assets/images/event8.png",
      month: "May",
      time: "5PM",
      category: "Technology",
      details: "The latest trends in app development.",
      hostedBy: "Google Developers",
      hostName: "Anna Smith",
    ),
    Event(
      id: '9',
      name: "VR & AR Innovations",
      date: "2024-04-05",
      location: "Los Angeles",
      imageUrl: "assets/images/event9.png",
      month: "April",
      time: "12PM",
      category: "Technology",
      details: "How virtual and augmented reality is evolving.",
      hostedBy: "Meta",
      hostName: "David Warner",
    ),

    // 🔹 9 UPCOMING EVENTS (After March 6, 2025)
    Event(
      id: '10',
      name: "Tech Summit 2025",
      date: "2025-03-10",
      location: "Alexandria",
      imageUrl: "assets/images/event1.png",
      month: "March",
      time: "10AM",
      category: "Technology",
      details: "A conference on the latest in tech.",
      hostedBy: "Tech Leaders",
      hostName: "Mark Johnson",
    ),
    Event(
      id: '11',
      name: "AI in Healthcare",
      date: "2025-04-15",
      location: "Boston",
      imageUrl: "assets/images/event2.png",
      month: "April",
      time: "1PM",
      category: "AI",
      details: "How AI is revolutionizing medicine.",
      hostedBy: "MedTech",
      hostName: "Dr. Alice Kim",
    ),
    Event(
      id: '12',
      name: "Cybersecurity Bootcamp",
      date: "2025-05-20",
      location: "San Diego",
      imageUrl: "assets/images/event3.png",
      month: "May",
      time: "3PM",
      category: "Security",
      details: "Intensive training on cyber defense.",
      hostedBy: "Security Experts",
      hostName: "Jake Nolan",
    ),
    Event(
      id: '13',
      name: "FinTech Innovations",
      date: "2025-06-05",
      location: "Singapore",
      imageUrl: "assets/images/event13.png",
      month: "June",
      time: "2PM",
      category: "Finance",
      details: "The future of digital banking and crypto.",
      hostedBy: "Banking Tech",
      hostName: "Sophia Lee",
    ),
    Event(
      id: '14',
      name: "Green Energy World",
      date: "2025-07-18",
      location: "Amsterdam",
      imageUrl: "assets/images/event14.png",
      month: "July",
      time: "9AM",
      category: "Environment",
      details: "Exploring renewable energy breakthroughs.",
      hostedBy: "GreenTech",
      hostName: "Tom Anderson",
    ),
    Event(
      id: '15',
      name: "Future of Work Summit",
      date: "2025-08-22",
      location: "Sydney",
      imageUrl: "assets/images/event15.png",
      month: "August",
      time: "4PM",
      category: "Business",
      details: "How AI and automation are reshaping jobs.",
      hostedBy: "HR Tech",
      hostName: "Emily Roberts",
    ),
    Event(
      id: '16',
      name: "Autonomous Vehicles Conference",
      date: "2025-09-30",
      location: "Munich",
      imageUrl: "assets/images/event16.png",
      month: "September",
      time: "11AM",
      category: "Automotive",
      details: "The self-driving future.",
      hostedBy: "AutoTech",
      hostName: "Oliver Brown",
    ),
    Event(
      id: '17',
      name: "Quantum Computing Summit",
      date: "2025-10-12",
      location: "Zurich",
      imageUrl: "assets/images/event17.png",
      month: "October",
      time: "2PM",
      category: "Technology",
      details: "Quantum computing breakthroughs.",
      hostedBy: "IBM Research",
      hostName: "William Zhang",
    ),
    Event(
      id: '18',
      name: "Space Colonization Forum",
      date: "2025-11-25",
      location: "Houston",
      imageUrl: "assets/images/event18.png",
      month: "November",
      time: "6PM",
      category: "Science",
      details: "Preparing for life beyond Earth.",
      hostedBy: "NASA & SpaceX",
      hostName: "Elon Musk",
    ),
  ];


  List<Event> getFilteredEvents() {
    DateTime now = DateTime.now();

    if (widget.filterType == "upcoming") {
      // Show only future events
      return allEvents.where((event) => DateTime.parse(event.date).isAfter(now)).toList();
    } else {
      // Show only past events
      return allEvents.where((event) => DateTime.parse(event.date).isBefore(now)).toList();
    }
  }
  void addMultipleEvents() async {
    List<Map<String, dynamic>> events = [
      {
        'id': '1',
        'name': "Tech Summit 2025",
        'date': "2025-04-10",
        'location': "Alexandria",
        'imageUrl': "assets/images/event1.png",
        'month': "April",
        'time': "10AM",
        'category': "Technology",
        'details': "A conference on the latest in tech.",
        'hostedBy': "Tech Leaders",
        'hostName': "Mark Johnson",
      },
      {
        'id': '2',
        'name': "AI Conference",
        'date': "2024-12-20",
        'location': "Cairo",
        'imageUrl': "assets/images/event2.png",
        'month': "December",
        'time': "2PM",
        'category': "AI",
        'details': "A deep dive into AI advancements.",
        'hostedBy': "Tech Association",
        'hostName': "Dr. Ahmed Ali",
      },
    ];

    for (var event in events) {
      try {
        await FirebaseFirestore.instance
            .collection('events') // ✅ Ensure collection name is 'events'
            .doc(event['id']) // ✅ Use 'id' as the document name to prevent duplicates
            .set(event);
        print("Event '${event['name']}' added successfully!");
      } catch (e) {
        print("Error adding event '${event['name']}': $e");
      }
    }
  }


  void showMoreEvents() {
    setState(() {
      displayedEventCount += increment;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Event> filteredEvents = getFilteredEvents();
    int eventsToShow = displayedEventCount.clamp(0, filteredEvents.length);

    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > 600 ? 3 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: eventsToShow,
            itemBuilder: (context, index) {
              return EventsCard(event: filteredEvents[index]);
            },
          ),
SizedBox(height: 30.sp,),
          // "See More" Button (Only show if there are more events)
          if (eventsToShow < filteredEvents.length)
            ElevatedButton(
              onPressed: showMoreEvents,
              style: ElevatedButton.styleFrom(
                backgroundColor: WebsiteColors.darkBlueColor,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().screenWidth < 500 ? 10.sp : 30.sp, // Smaller padding on small screens
                  vertical: ScreenUtil().screenWidth < 500 ? 4.sp : 12.sp,   // Reduce vertical padding
                ),
              ),
              child: Text(
                "See More",
                style: TextStyle(
                  fontSize: ScreenUtil().screenWidth < 400 ? 18.sp : 25.sp, // Decrease font size on small screens
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

        ],
      ),
    );
  }
}
