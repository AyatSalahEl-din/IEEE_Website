import 'package:flutter/material.dart';

class WallofHonur extends StatefulWidget {
  static const String routeName = 'wall_of_honur';
  final TabController? tabController; // ✅ Make TabController optional

  WallofHonur({super.key, this.tabController}); // ✅ Default to null

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
