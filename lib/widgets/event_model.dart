import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  final String name;
  final String location;
  final String time;
  final List<String> imageUrls; // ✅ Changed from single String to List<String>
  final String month;
  final DateTime date;
  final String category;
  // final String hostName;
  // final String hostedBy;
  final String details;

  Event({
    required this.name,
    required this.location,
    required this.time,
    required this.imageUrls, // ✅ List of images
    required this.month,
    required this.date,
    required this.category,
    // required this.hostName,
    // required this.hostedBy,
    required this.details,
  });

  /// ✅ Factory method to parse Firestore data
  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      name: data['name'] ?? 'No name',
      location: data['location'] ?? 'No location',
      time: data['time'] ?? 'No time',
      imageUrls: (data['imageUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], // ✅ Handles multiple images
      month: data['month'] ?? 'No month',
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? 'No category',
      // hostName: data['hostName'] ?? 'No host name',
      // hostedBy: data['hostedBy'] ?? 'No host by',
      details: data['details'] ?? 'No details',
    );
  }

  /// ✅ Format date to a readable format
  String formatDate() {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}

/// ✅ Fetch events from Firestore
Future<List<Event>> fetchEventsFromFirestore() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();

    if (snapshot.docs.isEmpty) {
      print("No events found in Firestore.");
    }

    List<Event> events = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("Fetched Event: $data"); // Debugging
      return Event.fromFirestore(data);
    }).toList();

    print("Total Events: ${events.length}");
    return events;
  } catch (e) {
    print("Error fetching events: $e");
    return [];
  }
}
