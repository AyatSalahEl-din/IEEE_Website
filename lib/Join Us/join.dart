import 'package:flutter/material.dart';

class JoinUs extends StatefulWidget {
  static const String routeName = 'join';
  final TabController? tabController; // ✅ Make TabController optional

  JoinUs({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
