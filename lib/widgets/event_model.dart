// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String date;
  final String location;
  final String imageUrl;
  final String month;
  final String time;
  final String category;
  final String details;
  final String hostedBy;
  final String hostName;

  Event({
    required this.details,
    required this.hostedBy,
    required this.hostName,
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.month,
    required this.time,
    required this.category,
  });

  // Convert Firestore document to Event object
  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      month: data['month'] ?? '',
      time: data['time'] ?? '',
      category: data['category'] ?? '',
      details: data['details'] ?? '',
      hostedBy: data['hostedBy'] ?? '',
      hostName: data['hostName']?? ''
    );
  }
}
