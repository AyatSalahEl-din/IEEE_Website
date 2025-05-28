import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';

class AboutDataService {
  static Future<AboutDataModel> fetchAllAboutData() async {
    final aboutSnapshot =
    await FirebaseFirestore.instance.collection('about').doc('main').get();

    Map<String, dynamic> mainData = {};
    if (aboutSnapshot.exists) {
      mainData = aboutSnapshot.data() ?? {};
    }

    final valuesSnapshot = await FirebaseFirestore.instance
        .collection('about')
        .doc('values')
        .collection('items')
        .get();

    final List<ValueItem> valuesData = [];
    for (var doc in valuesSnapshot.docs) {
      valuesData.add(ValueItem.fromMap(doc.data()));
    }

    return AboutDataModel(
      mainData: mainData,
      values: valuesData,
    );
  }
}
