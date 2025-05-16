class ContactMessage {
  final String name;
  final String email;
  final String message;
  final DateTime timestamp;

  ContactMessage({
    required this.name,
    required this.email,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
