import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  static const String routeName = 'events';
  final TabController? tabController; // ✅ Make TabController optional

  Events({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
