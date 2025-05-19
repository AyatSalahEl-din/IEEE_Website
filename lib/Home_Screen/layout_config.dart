import 'package:cloud_firestore/cloud_firestore.dart';

class LayoutConfig {
  final List<int> rowSizes;

  LayoutConfig({required this.rowSizes});

  factory LayoutConfig.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final sizes = List<int>.from(data['sizes']);
    return LayoutConfig(rowSizes: sizes);
  }

}

