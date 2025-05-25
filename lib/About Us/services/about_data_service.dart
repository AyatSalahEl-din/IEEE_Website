import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';

class AboutDataService {
  static Future<AboutDataModel> fetchAllAboutData() async {
    // Fetch main about data
    final aboutSnapshot =
        await FirebaseFirestore.instance.collection('about').doc('main').get();

    Map<String, dynamic> mainData = {};
    if (aboutSnapshot.exists) {
      mainData = aboutSnapshot.data() ?? {};
    }

    // Fetch values data
    final valuesSnapshot = await FirebaseFirestore.instance
        .collection('about')
        .doc('values')
        .collection('items')
        .get();

    final List<ValueItem> valuesData = [];
    for (var doc in valuesSnapshot.docs) {
      valuesData.add(ValueItem.fromMap(doc.data()));
    }

    // Get video URL from Firebase Storage
    final videoRef =
        FirebaseStorage.instance.ref().child('videos/IEEE_Video.mp4');
    String videoUrl;

    try {
      videoUrl = await videoRef.getDownloadURL();
    } catch (e) {
      // Fallback to local asset
      videoUrl = 'assets/video/IEEE_Video.mp4';
    }

    return AboutDataModel(
      mainData: mainData,
      values: valuesData,
      videoUrl: videoUrl,
    );
  }
}
