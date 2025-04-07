import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/contact_model.dart';

class ContactFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(ContactMessage message) async {
    try {
      await _firestore.collection('contact_messages').add(message.toMap());
    } catch (e) {
      print('Error sending message to Firestore: $e');
      rethrow;
    }
  }
}
