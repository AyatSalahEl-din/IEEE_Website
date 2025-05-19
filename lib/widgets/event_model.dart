import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  final String name;
  final String location;
  final String time;
  final List<String> imageUrls;

  final String month;
  final DateTime date;
  final String category;
  // final String hostName;
  // final String hostedBy;
  final String details;
  final double? discount; // Discount amount
  final String? discountFor; // Group eligible for discount
  final double? baseTicketPrice; // Base ticket price
  final bool isOnlineEvent; // Whether the event is online
  final String? appName; // Online event app name
  final String? appUrl; // Online event URL
  final String? appTime; // Online event time
  final BusDetails? busDetails; // Bus details for the event
  final String? contactNumber; // Admin-provided contact number
  final String? contactEmail; // Admin-provided contact email
  final bool? isTicketAvailable; // Whether tickets are available
  final bool? isTicketLimited; // Whether tickets are limited
  final int? ticketLimit; // Ticket limit if applicable
  final bool? hasBusService; // Whether the event has bus service
  final bool? isSeatBookingAvailable;
  
  var id; // Whether seat booking is available

  Event({
    required this.id,
    required this.name,
    required this.location,
    required this.time,
    required this.imageUrls,
    required this.month,
    required this.date,
    required this.category,
    required this.details,
    this.discount,
    this.discountFor,
    this.baseTicketPrice,
    this.isOnlineEvent = false,
    this.appName,
    this.appUrl,
    this.appTime,
    this.busDetails,
    this.contactNumber,
    this.contactEmail,
    this.isTicketAvailable,
    this.isTicketLimited,
    this.ticketLimit,
    this.hasBusService,
    this.isSeatBookingAvailable,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Ensure proper casting
    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      time: data['time'] ?? '',
      imageUrls:
          (data['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      month: data['month'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? '',
      details: data['details'] ?? '',
      discount: _parseDouble(data['discount']),
      discountFor: data['discountFor'],
      baseTicketPrice: _parseDouble(data['ticketPrice']),
      isOnlineEvent: data['isOnlineEvent'] ?? false,
      appName: data['appName'],
      appUrl: data['appUrl'],
      appTime: data['appTime'],
      busDetails:
          data['busDetails'] != null
              ? BusDetails.fromMap(data['busDetails'])
              : null,
      contactNumber: data['contact']?['number'],
      contactEmail: data['contact']?['email'],
      isTicketAvailable: data['isTicketAvailable'],
      isTicketLimited: data['isTicketLimited'],
      ticketLimit: data['ticketLimit'],
      hasBusService: data['hasBusService'],
      isSeatBookingAvailable: data['isSeatBookingAvailable'],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.replaceAll('%', '').trim());
      return parsed;
    }
    return null;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'time': time,
      'imageUrls': imageUrls,
      'month': month,
      'date': date,
      'category': category,
      'details': details,
      if (discount != null) 'discount': discount,
      if (discountFor != null) 'discountFor': discountFor,
      if (baseTicketPrice != null) 'ticketPrice': baseTicketPrice,
      'isOnlineEvent': isOnlineEvent,
      if (appName != null) 'appName': appName,
      if (appUrl != null) 'appUrl': appUrl,
      if (appTime != null) 'appTime': appTime,
      if (busDetails != null) 'busDetails': busDetails!.toMap(),
      'contact': {
        if (contactNumber != null) 'number': contactNumber,
        if (contactEmail != null) 'email': contactEmail,
      },
      'isTicketAvailable': isTicketAvailable,
      'isTicketLimited': isTicketLimited,
      'ticketLimit': ticketLimit,
      'hasBusService': hasBusService,
      'isSeatBookingAvailable': isSeatBookingAvailable,
    };
  }

  String formatDate() {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  /// Generate Bus Details as a formatted string
  String getBusDetails() {
    if (busDetails == null) return '';
    return '''
Bus Details:
- Departure Location: ${busDetails!.departureLocation}
- Arrival Location: ${busDetails!.arrivalLocation}
- Departure Time: ${busDetails!.departureTime}
''';
  }

  /// Generate Online Event Details as a formatted string
  String getOnlineEventDetails() {
    if (!isOnlineEvent) return '';
    return '''
Online Event Details:
- App: ${appName ?? 'Not provided'}
- URL: ${appUrl ?? 'Not provided'}
- Time: ${appTime ?? 'Not provided'}
''';
  }

  /// Generate Contact Details as a formatted string
  String getContactDetails() {
    return '''
Contact Details:
- Phone: ${contactNumber ?? 'Not provided'}
- Email: ${contactEmail ?? 'Not provided'}
''';
  }
}

class BusDetails {
  final String departureLocation;
  final String arrivalLocation;
  final String departureTime;
  final double busTicketPrice;

  BusDetails({
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureTime,
    required this.busTicketPrice,
  });

  factory BusDetails.fromMap(Map<String, dynamic> data) {
    return BusDetails(
      departureLocation: data['departureLocation'] ?? '',
      arrivalLocation: data['arrivalLocation'] ?? '',
      departureTime: data['departureTime'] ?? '',
      busTicketPrice: (data['ticketPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'departureLocation': departureLocation,
      'arrivalLocation': arrivalLocation,
      'departureTime': departureTime,
      'ticketPrice': busTicketPrice,
    };
  }
}

class TicketRequest {
  final String id;
  final String userName;
  final String userPhone;
  final String? userEmail;
  final String eventName;
  final Timestamp requestDate;
  final String status;
  final String? additionalUserInfo;
  final String? ticketType;
  final int? ticketQuantity;
  final bool? busService;
  final Map<String, dynamic>? busDetails;
  final String? rejectReason;
  final String? notes;
  final Timestamp? eventDate;

  TicketRequest({
    required this.id,
    required this.userName,
    required this.userPhone,
    this.userEmail,
    required this.eventName,
    required this.requestDate,
    required this.status,
    this.additionalUserInfo,
    this.ticketType,
    this.ticketQuantity,
    this.busService,
    this.busDetails,
    this.rejectReason,
    this.notes,
    this.eventDate,
  });

  factory TicketRequest.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return TicketRequest(
      id: doc.id,
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      userEmail: data['userEmail'],
      eventName: data['eventName'] ?? '',
      requestDate: data['requestDate'] ?? Timestamp.now(),
      status: data['status'] ?? 'pending',
      additionalUserInfo: data['additionalUserInfo'],
      ticketType: data['ticketType'],
      ticketQuantity: data['ticketQuantity'],
      busService: data['busService'],
      busDetails:
          data['busDetails'] != null
              ? Map<String, dynamic>.from(data['busDetails'])
              : null,
      rejectReason: data['rejectReason'],
      notes: data['notes'],
      eventDate: data['eventDate'],

    );
  }
  
  DateTime? get date => null;

  /// ✅ Format date to a readable format
  String formatDate() {
    return DateFormat('yyyy-MM-dd HH:mm').format(date!);
  }
}

/// ✅ Fetch events from Firestore
Future<List<Event>> fetchAllEventsFromFirestore() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();

    if (snapshot.docs.isEmpty) {
      print("No events found in Firestore.");
    }

    List<Event> events = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("Fetched Event: $data"); // Debugging
      return Event.fromFirestore(data as DocumentSnapshot<Object?>);
    }).toList();

    print("Total Events: ${events.length}");
    return events;
  } catch (e) {
    print("Error fetching events: $e");
    return [];
  }
}

class Proposal {
  final String id;
  final String name;
  final String requester;
  final String contact;
  final String description;
  final String location;
  final String category;
  final Timestamp proposedDate;
  final String coverImageUrl;
  final String additionalDetails;
  final double baseTicketPrice;
  final Timestamp submittedAt;

  Proposal({
    required this.id,
    required this.name,
    required this.requester,
    required this.contact,
    required this.description,
    required this.location,
    required this.category,
    required this.proposedDate,
    required this.coverImageUrl,
    required this.additionalDetails,
    required this.baseTicketPrice,
    required this.submittedAt,
  });

  factory Proposal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Proposal(
      id: doc.id,
      name: data['name'] ?? '',
      requester: data['requester'] ?? '',
      contact: data['contact'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      category: data['category'] ?? 'Workshop',
      proposedDate: data['proposedDate'] ?? Timestamp.now(),
      coverImageUrl: data['coverImageUrl'] ?? '',
      additionalDetails: data['additionalDetails'] ?? '',
      baseTicketPrice: (data['baseTicketPrice'] ?? 0).toDouble(),
      submittedAt: data['submittedAt'] ?? Timestamp.now(),
    );
  }
}

Future<List<Event>> fetchEventsFromFirestore() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();

    if (snapshot.docs.isEmpty) {
      print("No events found in Firestore.");
    }

    List<Event> events =
        snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          print("Fetched Event: $data"); // Debugging
          return Event.fromFirestore(doc);
        }).toList();

    print("Total Events: ${events.length}");
    return events;
  } catch (e) {
    print("Error fetching events: $e");
    return [];
  }
}
