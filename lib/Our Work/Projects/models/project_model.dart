class Project {
  final String id;
  final String title;
  final String description;
  final String madeBy;
  final DateTime date;
  final List<String> tags;
  final String imageUrl;
  final Map<String, dynamic>? additionalDetails; // For flexible additional data

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.madeBy,
    required this.date,
    required this.tags,
    required this.imageUrl,
    this.additionalDetails,
  });

  // Convert from Firebase/JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      madeBy: json['madeBy'] as String,
      date: DateTime.parse(json['date'] as String),
      tags: List<String>.from(json['tags'] as List),
      imageUrl: json['imageUrl'] as String,
      additionalDetails: json['additionalDetails'] as Map<String, dynamic>?,
    );
  }

  // Convert to Firebase/JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'madeBy': madeBy,
      'date': date.toIso8601String(),
      'tags': tags,
      'imageUrl': imageUrl,
      if (additionalDetails != null) 'additionalDetails': additionalDetails,
    };
  }

  // Search helper method
  bool matchesSearch(String query) {
    final searchQuery = query.toLowerCase();
    return title.toLowerCase().contains(searchQuery) ||
           description.toLowerCase().contains(searchQuery) ||
           madeBy.toLowerCase().contains(searchQuery) ||
           tags.any((tag) => tag.toLowerCase().contains(searchQuery)) ||
           (additionalDetails?.values.any((value) => 
             value.toString().toLowerCase().contains(searchQuery)) ?? false);
  }
}
