import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Home_Screen/hover_animated_card.dart';
import 'package:ieee_website/Home_Screen/main_section.dart';
import 'package:ieee_website/Home_Screen/teammemberclass.dart';
import 'package:ieee_website/Home_Screen/welcome_section.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/widgets/card.dart';
import 'package:ieee_website/widgets/footer.dart';
import 'package:ieee_website/widgets/home_screen_feature_button.dart';
import 'package:ieee_website/widgets/storyslider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';
  final TabController? tabController;

  HomeScreen({super.key, this.tabController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _announcementShown = false;

  final List<String> imageUrls = [
    'assets/images/Picture1.png',
    'assets/images/Picture2.png',
    'assets/images/Picture3.png',
    'assets/images/Picture4.png',
    'assets/images/Picture5.png',
    'assets/images/Picture6.png',
  ];

  final GlobalKey ourStoryKey = GlobalKey();

  void scrollToOurStory() {
    final context = ourStoryKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Stack(
            children: [
              MainSection(onStoryTap: scrollToOurStory),
              HomeScreenFeatureButton(
                left: 1391.sp,
                top: 393.sp,

                onTap: () => widget.tabController!.animateTo(2),
                child: Row(
                  children: [
                    Container(
                      height: 50.sp,
                      width: 50.sp,
                      decoration: BoxDecoration(
                        color: WebsiteColors.primaryBlueColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: WebsiteColors.whiteColor,
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 15.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upcoming Events",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          "Book your seats",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              HomeScreenFeatureButton(
                left: 1000.sp,
                top: 577.sp,
                onTap: () => widget.tabController!.animateTo(5),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: WebsiteColors.visionColor,
                      size: 63.sp,
                    ),
                    SizedBox(width: 15.sp),
                    Text(
                      "New Features",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),

              HomeScreenFeatureButton(
                left: 1400.sp,
                top: 750.sp,
                onTap: () => widget.tabController!.animateTo(3),
                child: Row(
                  children: [
                    Container(
                      height: 50.sp,
                      width: 50.sp,
                      decoration: BoxDecoration(
                        color: WebsiteColors.primaryYellowColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb,
                        color: WebsiteColors.whiteColor,
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 15.sp),
                    Text(
                      "Papers and Projects",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 80.sp),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WelcomeSection(),
              Text("Our Vision", style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 40.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: HoverAnimatedCard(
                      child: InfoCard(
                        icon: Icons.groups,
                        iconColor: WebsiteColors.primaryBlueColor,
                        title:
                            "Strengthen the Branch through Structured Recruitment",
                        description:
                            "Implement a two-phase recruitment process: \nPhase 1: Select committed board members for leadership.\nPhase 2: Open recruitment for broader member engagement.",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: HoverAnimatedCard(
                      child: InfoCard(
                        icon: Icons.library_books,
                        iconColor: WebsiteColors.primaryYellowColor,
                        title: "Enhance Members’ Skills",
                        description:
                            "Foster lifelong learning for career growth.\nOffer training in AI, CS, Robotics, and more.\nProvide hands-on workshops for practical experience.\nPrepare members for IEEE Xtreme competition.",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: HoverAnimatedCard(
                      child: InfoCard(
                        icon: Icons.handshake,
                        iconColor: WebsiteColors.primaryBlueColor,
                        title: "Enhance Community Outreach and Engagement",
                        description:
                            "Expand influence through community service and outreach events.\nOrganize networking sessions, technical meetups, and volunteer activities.",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: HoverAnimatedCard(
                      child: InfoCard(
                        icon: Icons.autorenew,
                        iconColor: WebsiteColors.primaryYellowColor,
                        title: "Facilitate Continuous Development",
                        description:
                            "Design programs, workshops, and initiatives that promote ongoing learning and skill-building throughout a volunteer’s journey.",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: HoverAnimatedCard(
                      child: InfoCard(
                        icon: Icons.design_services,
                        iconColor: WebsiteColors.primaryBlueColor,
                        title:
                            "Enhance Website Functionality and User Experience",
                        description:
                            "Improve the website’s design, functionality, and user experience to showcase the branch’s efforts and capabilities effectively.",
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  key: ourStoryKey,
                  child: Column(
                    children: [
                      SizedBox(height: 550.h),
                      Text(
                        "Our Story",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        "IEEE PUA SB Accomplishments 2014-2025",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: WebsiteColors.descGreyColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              StorySlideshow(),
              SizedBox(height: 100.h),
              OurTeamSection(),
              SizedBox(height: 500.h),
              Text(
                "Our Partners",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 40.h),
              Image.asset(
                'assets/images/Partners.png',
                height: 1563.sp,
                width: 1607.sp,
              ),
            ],
          ),

          if (widget.tabController != null)
            Footer(tabController: widget.tabController!),
        ],
      ),
    );
  }
}
