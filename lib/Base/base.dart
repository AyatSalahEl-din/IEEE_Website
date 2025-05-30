import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/About%20Us/about.dart';
import 'package:ieee_website/Contact%20Us/contact.dart';
import 'package:ieee_website/FAQ/faq.dart';
import 'package:ieee_website/Home_Screen/home_screen.dart';
import 'package:ieee_website/Home_Screen/url_helper.dart';
import 'package:ieee_website/Our%20Work/Events/events.dart';
import 'package:ieee_website/Our%20Work/Projects/projects.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Tools&Features/tools.dart';

class Base extends StatefulWidget {
  static const String routeName = 'base';

  Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: WebsiteColors.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: WebsiteColors.whiteColor),
        toolbarHeight: 120.sp,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: WebsiteColors.primaryBlueColor.withOpacity(0.7),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.sp),
          child: Builder(
            builder: (context) {
              // Get the screen width
              double screenWidth = MediaQuery.of(context).size.width;

              // Define a breakpoint for switching layouts
              if (screenWidth < 1000) {
                // For small screens, show a Drawer (hamburger menu)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/whitehoriz.png',
                      height: 170.sp,
                      width: 160.sp,
                    ),
                  ],
                );
              } else {
                // For larger screens, show the TabBar and Join Us button
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/whitehoriz.png',
                      height: 170.sp,
                      width: 160.sp,
                    ),
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: WebsiteColors.whiteColor,
                      unselectedLabelStyle:
                          Theme.of(context).textTheme.displayMedium,
                      labelStyle: Theme.of(context).textTheme.displaySmall,
                      tabs: const [
                        Tab(text: "Home"),
                        Tab(text: "About Us"),
                        Tab(text: "Events"),
                        Tab(text: "Projects"),
                        Tab(text: "Contact Us"),
                        Tab(text: "Tools"),
                        Tab(text: "FAQ"),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WebsiteColors.whiteColor,
                        foregroundColor: WebsiteColors.primaryBlueColor,
                        fixedSize: Size(190.sp, 50.sp),
                      ),
                      onPressed: () {
                        UrlHelper.fetchAndLaunchURL('joinUs');
                      },
                      child: Text(
                        'Join Us',
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(
                          fontSize: 25.sp,
                          color: WebsiteColors.primaryBlueColor,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      endDrawer:
          MediaQuery.of(context).size.width < 1000
              ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: WebsiteColors.primaryBlueColor,
                      ),
                      child: Text(
                        'Tabs',
                        style: TextStyle(
                          color: WebsiteColors.whiteColor,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Home'),
                      onTap: () {
                        _tabController.animateTo(0);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('About Us'),
                      onTap: () {
                        _tabController.animateTo(1);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Events'),
                      onTap: () {
                        _tabController.animateTo(2);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Projects'),
                      onTap: () {
                        _tabController.animateTo(3);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Contact Us'),
                      onTap: () {
                        _tabController.animateTo(4);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Tools'),
                      onTap: () {
                        _tabController.animateTo(5);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('FAQ'),
                      onTap: () {
                        _tabController.animateTo(6);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Join Us'),
                      onTap: () {
                        UrlHelper.fetchAndLaunchURL('joinUs');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              )
              : null, // No drawer for large screens
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreen(
            tabController: _tabController,
          ), // ✅ Pass _tabController to HomeScreen
          AboutUs(tabController: _tabController),
          Events(tabController: _tabController),
          Projects(tabController: _tabController),
          Contact(tabController: _tabController),
          Tools(tabController: _tabController),
          FAQ(tabController: _tabController),
        ],
      ),
    );
  }
}
