import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String? madeBy; // Optional
  final DateTime date;
  final List<String> tags;
  final List<String>? imageUrls; // Optional
  final Map<String, dynamic>? additionalDetails;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.madeBy, // Optional
    required this.date,
    required this.tags,
    this.imageUrls, // Optional
    this.additionalDetails,
  });

  // Convert from Firebase/JSON
  factory Project.fromFirestore(Map<String, dynamic> json, String id) {
    try {
      final List<String>? imageUrls =
          json['imageUrls'] != null
              ? List<String>.from(json['imageUrls'] as List)
                  .where((url) => url.isNotEmpty)
                  .toList() // Filter out empty URLs
              : [];
      return Project(
        id: id,
        title: json['title'] as String? ?? 'Untitled Project', // Default title
        description:
            json['description'] as String? ??
            'No description provided', // Default description
        madeBy:
            json['madeBy'] as String? ?? 'Unknown', // Default value for madeBy
        date:
            json['date'] != null
                ? (json['date'] is Timestamp
                    ? (json['date'] as Timestamp).toDate()
                    : DateTime.tryParse(json['date'] as String) ??
                        DateTime.now())
                : DateTime.now(), // Handle both Timestamp and String formats
        tags: List<String>.from(
          json['tags'] as List? ?? [],
        ), // Default to empty list if null
        imageUrls: imageUrls, // Ensure this is correctly mapped
        additionalDetails:
            json['additionalDetails'] as Map<String, dynamic>? ??
            {}, // Default to empty map
      );
    } catch (e) {
      debugPrint('Error in Project.fromFirestore for ID $id: $e'); // Debug log
      rethrow;
    }
  }

  // Convert to Firebase/JSON
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      if (madeBy != null) 'madeBy': madeBy,
      'date': date.toIso8601String(),
      'tags': tags,
      if (imageUrls != null) 'imageUrls': imageUrls,
      if (additionalDetails != null) 'additionalDetails': additionalDetails,
    };
  }

  // Search helper method
  bool matchesSearch(String query) {
    final searchQuery = query.toLowerCase();
    return title.toLowerCase().contains(searchQuery) ||
        description.toLowerCase().contains(searchQuery) ||
        (madeBy?.toLowerCase().contains(searchQuery) ?? false) ||
        tags.any((tag) => tag.toLowerCase().contains(searchQuery)) ||
        (additionalDetails?.values.any(
              (value) => value.toString().toLowerCase().contains(searchQuery),
            ) ??
            false);
  }
}
