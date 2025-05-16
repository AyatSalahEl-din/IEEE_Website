import 'package:flutter/material.dart';

class Tools extends StatefulWidget {
  static const String routeName = 'tools';
  final TabController? tabController; // ✅ Make TabController optional

  Tools({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
