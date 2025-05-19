// lib/utils/url_helper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> fetchAndLaunchURL(String docName) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('links')
              .doc(docName)
              .get();

      String url = doc['url'];
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch URL: $url");
      }
    } catch (e) {
      print("Error fetching or launching URL from $docName: $e");
    }
  }
}
