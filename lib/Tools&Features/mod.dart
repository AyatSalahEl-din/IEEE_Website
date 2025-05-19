import 'package:cloud_firestore/cloud_firestore.dart';
class Event {
  final String id;
  final String name;
  final String description;
  final String location;
  final String category;
  final DateTime date;
  final String coverImageUrl;
  final String additionalDetails;
  final double baseTicketPrice;
  final bool discountOption;
  final double discountAmount;
  final DateTime? discountValidUntil;
  final bool hasBusService;
  final BusDetails? busDetails;
  final List<String> galleryImages;
  final bool isPastEvent;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.date,
    required this.coverImageUrl,
    required this.additionalDetails,
    required this.baseTicketPrice,
    required this.discountOption,
    required this.discountAmount,
    this.discountValidUntil,
    required this.hasBusService,
    this.busDetails,
    required this.galleryImages,
    required this.isPastEvent,
  });

  // Add fromFirestore method if needed
  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      category: data['category'] ?? 'Workshop',
      date: (data['date'] as Timestamp).toDate(),
      coverImageUrl: data['coverImageUrl'] ?? '',
      additionalDetails: data['additionalDetails'] ?? '',
      baseTicketPrice: (data['baseTicketPrice'] ?? 0).toDouble(),
      discountOption: data['discountOption'] ?? false,
      discountAmount: (data['discountAmount'] ?? 0).toDouble(),
      discountValidUntil: data['discountValidUntil']?.toDate(),
      hasBusService: data['hasBusService'] ?? false,
      busDetails: data['busDetails'] != null 
          ? BusDetails.fromMap(data['busDetails']) 
          : null,
      galleryImages: List<String>.from(data['galleryImages'] ?? []),
      isPastEvent: data['isPastEvent'] ?? false,
    );
  }
}

class BusDetails {
  final String departureLocation;
  final String arrivalLocation;
  final String tripProgram;
  final double busTicketPrice;
  final int totalSeats;
  final bool enableSeatSelection;

  BusDetails({
    required this.departureLocation,
    required this.arrivalLocation,
    required this.tripProgram,
    required this.busTicketPrice,
    required this.totalSeats,
    required this.enableSeatSelection,
  });

  factory BusDetails.fromMap(Map data) {
    return BusDetails(
      departureLocation: data['departureLocation'] ?? '',
      arrivalLocation: data['arrivalLocation'] ?? '',
      tripProgram: data['tripProgram'] ?? '',
      busTicketPrice: (data['busTicketPrice'] ?? 0).toDouble(),
      totalSeats: (data['totalSeats'] ?? 0).toInt(),
      enableSeatSelection: data['enableSeatSelection'] ?? false,
    );
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
      busDetails: data['busDetails'] != null 
          ? Map<String, dynamic>.from(data['busDetails']) 
          : null,
      rejectReason: data['rejectReason'],
      notes: data['notes'],
      eventDate: data['eventDate'],
    );
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