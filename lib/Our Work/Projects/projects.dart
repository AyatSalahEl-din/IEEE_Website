import 'package:flutter/material.dart';

class Projects extends StatefulWidget {
  static const String routeName = 'projects';
  final TabController? tabController; // ✅ Make TabController optional

  Projects({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
