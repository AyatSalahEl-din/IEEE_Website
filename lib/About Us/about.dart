import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  static const String routeName = 'about';
  final TabController? tabController; // ✅ Make TabController optional

  AboutUs({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
