import 'package:flutter/material.dart';
import 'package:ieee_website/About%20Us/about.dart';
import 'package:ieee_website/Base/base.dart';
import 'package:ieee_website/Contact%20Us/contact.dart';
import 'package:ieee_website/FAQ/faq.dart';
import 'package:ieee_website/Home_Screen/home_screen.dart';
import 'package:ieee_website/Join%20Us/join.dart';
import 'package:ieee_website/Our%20Work/Events/events.dart';
import 'package:ieee_website/Our%20Work/Projects/projects.dart';
import 'package:ieee_website/Themes/my_theme.dart';
import 'package:ieee_website/Tools&Features/tools.dart';
import 'package:ieee_website/Wall%20Of%20Honur/wallofhonur.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IEEE PUA SB',
      theme: MyTheme.theme,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        AboutUs.routeName: (context) => AboutUs(),
        Events.routeName: (context) => Events(),
        Projects.routeName: (context) => Projects(),
        Contact.routeName: (context) => Contact(),
        Tools.routeName: (context) => Tools(),
        JoinUs.routeName: (context) => JoinUs(),
        Base.routeName: (context) => Base(),
        FAQ.routeName: (context) => FAQ(),
        WallofHonur.routeName: (context) => WallofHonur(),
      },
    );
  }
}
