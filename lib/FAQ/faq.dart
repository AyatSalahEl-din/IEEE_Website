import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  static const String routeName = 'faq';
  final TabController? tabController; // ✅ Make TabController optional

  FAQ({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
