import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  static const String routeName = 'Contact';
  final TabController? tabController; // ✅ Make TabController optional

  Contact({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
