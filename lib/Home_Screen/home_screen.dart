import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Join%20Us/join.dart';
import 'package:ieee_website/Our%20Work/Events/events.dart';
import 'package:ieee_website/Our%20Work/Projects/projects.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Tools&Features/tools.dart';
import 'package:ieee_website/Widgets/text_gradeint.dart';
import 'package:ieee_website/widgets/card.dart';
import 'package:ieee_website/widgets/footer.dart';
import 'package:ieee_website/widgets/imageslider.dart';
import 'package:ieee_website/widgets/team_member.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';
  final TabController? tabController; // ✅ Make TabController optional

  HomeScreen({super.key, this.tabController}); // ✅ Default to null
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageUrls = [
    'assets/images/Picture1.png',
    'assets/images/Picture2.png',
    'assets/images/Picture3.png',
    'assets/images/Picture4.png',
    'assets/images/Picture5.png',
    'assets/images/Picture6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          // Gradient Overlay & Image Slider
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 1118.sp,

                  autoPlay: true,
                  viewportFraction: 1.0,
                ),
                items:
                    imageUrls.map((imagePath) {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(900.sp, 100.sp),
                          bottomLeft: Radius.elliptical(900.sp, 100.sp),
                        ),
                        child: Image.asset(
                          imagePath,
                          width: 1920.sp,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
              ),

              ///gradeint
              Container(
                height: 1118.sp,
                width: 1920.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(900.sp, 100.sp),
                    bottomLeft: Radius.elliptical(900.sp, 100.sp),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      WebsiteColors.primaryBlueColor.withOpacity(0.7),
                      WebsiteColors.gradeintBlueColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              ///text and buttons :
              Positioned(
                left: 133.sp,
                top: 335.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "IEEE Pharos University in Alexandria",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Where Innovation Meets Excellence",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
                    SizedBox(
                      width: 803.sp,
                      child: Text(
                        "Join us in shaping a future where technology and creativity unite, and where every member has the opportunity to thrive. Together, we’re not just building a community—we’re building a brighter tomorrow.",
                        style: Theme.of(context).textTheme.displayMedium,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 20.sp),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WebsiteColors.primaryBlueColor,
                            foregroundColor: WebsiteColors.whiteColor,
                            fixedSize: Size(220.sp, 80.sp),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => JoinUs()),
                            );
                          },
                          child: Text(
                            "Join Us",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                        SizedBox(width: 20.sp),
                        ////our storyy
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: WebsiteColors.whiteColor,
                          ),
                          onPressed: () {
                            ////move to our story slider
                          },
                          child: Icon(
                            Icons.play_arrow,
                            color: WebsiteColors.primaryYellowColor,
                            size: 60.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// 📌 Upcoming Events Button
              Positioned(
                left: 1391.sp,
                top: 393.sp,
                child: MouseRegion(
                  cursor:
                      SystemMouseCursors.click, // ✅ Change cursor when hovered
                  child: GestureDetector(
                    onTap: () {
                      widget.tabController!.animateTo(2);
                    },
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: 200,
                      ), // ✅ Smooth hover effect
                      width: 341.sp,
                      height: 100.sp,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.sp,
                        vertical: 15.sp,
                      ),
                      decoration: BoxDecoration(
                        color: WebsiteColors.whiteColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20.sp),
                        boxShadow: [
                          BoxShadow(
                            color: WebsiteColors.primaryBlueColor.withOpacity(
                              0.1,
                            ),
                            blurRadius: 10.sp,
                            spreadRadius: 2.sp,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon Container
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
                          // Text Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                ),
              ),

              /// 📌 New Features Button
              Positioned(
                left: 1046.sp,
                top: 577.sp,
                child: MouseRegion(
                  cursor:
                      SystemMouseCursors.click, // ✅ Change cursor when hovered
                  child: GestureDetector(
                    onTap: () {
                      widget.tabController!.animateTo(5);
                    },
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: 200,
                      ), // ✅ Smooth hover effect
                      width: 323.sp,
                      height: 113.sp,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.sp,
                        vertical: 15.sp,
                      ),
                      decoration: BoxDecoration(
                        color: WebsiteColors.whiteColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20.sp),
                        boxShadow: [
                          BoxShadow(
                            color: WebsiteColors.primaryBlueColor.withOpacity(
                              0.1,
                            ),
                            blurRadius: 10.sp,
                            spreadRadius: 2.sp,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: WebsiteColors.visionColor,
                            size: 63.sp,
                          ),
                          SizedBox(width: 15.sp),
                          // Text Column
                          Text(
                            "New Features",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// 📌 Papers & Projects Button
              Positioned(
                left: 1449.sp,
                top: 726.sp,
                child: MouseRegion(
                  cursor:
                      SystemMouseCursors.click, // ✅ Change cursor when hovered
                  child: GestureDetector(
                    onTap: () {
                      widget.tabController!.animateTo(3);
                    },
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: 200,
                      ), // ✅ Smooth hover effect
                      width: 370.sp,
                      height: 110.sp,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.sp,
                        vertical: 15.sp,
                      ),
                      decoration: BoxDecoration(
                        color: WebsiteColors.whiteColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20.sp),
                        boxShadow: [
                          BoxShadow(
                            color: WebsiteColors.primaryBlueColor.withOpacity(
                              0.1,
                            ),
                            blurRadius: 10.sp,
                            spreadRadius: 2.sp,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon Container
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
                          // Text Column
                          Text(
                            "Papers and Projects",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 80.sp),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to ",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    "IEEE Pharos Student Branch",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Text(
                "where innovation meets passion!",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 30.sp),
              Container(
                width: 900.sp,
                height: 200.sp,
                child: Text(
                  "At Pharos SB, we believe in empowering students to explore, create, and lead. Whether you're diving into cutting-edge projects, attending transformative events, or collaborating with like-minded peers, this is your space to grow and make an impact.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GradientText(
                        text: "150",
                        style: GoogleFonts.abel(fontSize: 120.sp),
                        gradient: LinearGradient(
                          colors: [
                            WebsiteColors.primaryBlueColor,
                            WebsiteColors.gradeintBlueColor,
                          ], // Customize colors
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      Text(
                        "Members",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  SizedBox(width: 120.sp),
                  Column(
                    children: [
                      GradientText(
                        text: "14",
                        style: GoogleFonts.abel(fontSize: 120.sp),
                        gradient: LinearGradient(
                          colors: [
                            WebsiteColors.primaryBlueColor,
                            WebsiteColors.gradeintBlueColor,
                          ], // Customize colors
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      Text(
                        "Years",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 200.sp),
              /////////////////////Our vision
              Text("Our Vision", style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 40.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InfoCard(
                      icon: Icons.groups,
                      iconColor: WebsiteColors.primaryBlueColor,
                      title:
                          "Strengthen the Branch through Structured Recruitment",
                      description:
                          "Implement a two-phase recruitment process: \nPhase 1: Select committed board members for leadership.\nPhase 2: Open recruitment for broader member engagement.",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InfoCard(
                      icon: Icons.library_books,
                      iconColor: WebsiteColors.primaryYellowColor,
                      title: "Enhance Members’ Skills",
                      description:
                          "Foster lifelong learning for career growth.\nOffer training in AI, CS, Robotics, and more.\nProvide hands-on workshops for practical experience.\nPrepare members for IEEE Xtreme competition.",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InfoCard(
                      icon: Icons.handshake,
                      iconColor: WebsiteColors.primaryBlueColor,
                      title: "Enhance Community Outreach and Engagement",
                      description:
                          "Expand influence through community service and outreach events.\nOrganize networking sessions, technical meetups, and volunteer activities.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InfoCard(
                      icon: Icons.autorenew,
                      iconColor: WebsiteColors.primaryYellowColor,
                      title: "Facilitate Continuous Development",
                      description:
                          "Design programs, workshops, and initiatives that promote ongoing learning and skill-building throughout a volunteer’s journey.",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InfoCard(
                      icon: Icons.design_services,
                      iconColor: WebsiteColors.primaryBlueColor,
                      title:
                          "Enhance Website Functionality and User Experience",
                      description:
                          "Improve the website’s design, functionality, and user experience to showcase the branch’s efforts and capabilities effectively.",
                    ),
                  ),
                ],
              ),
              /////////////////////////
              ///Our Story
              SizedBox(height: 150.sp),
              Text("Our Story", style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 40.sp),
              Text(
                "IEEE PUA SB Accomplishments 2013-2023",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: WebsiteColors.descGreyColor,
                ),
              ),
              SizedBox(height: 20.sp),
              ContinuousSlideshow(),
              /////////////////////////
              ///Our team
              SizedBox(height: 200.sp),
              Text(
                "Meet Our Team",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 40.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TeamMemberCard(
                    imagePath: 'assets/images/Picture1.png',
                    name: "Ayat SalahEldin",
                    jobTitle: 'Software Engineer',
                  ),
                  SizedBox(width: 20.sp),
                  TeamMemberCard(
                    imagePath: 'assets/images/Picture2.png',
                    name: "Ayat SalahEldin",
                    jobTitle: 'Software Engineer',
                  ),
                  SizedBox(width: 20.sp),
                  TeamMemberCard(
                    imagePath: 'assets/images/Picture3.png',
                    name: "Ayat SalahEldin",
                    jobTitle: 'Software Engineer',
                  ),
                ],
              ),
              SizedBox(height: 40.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TeamMemberCard(
                    imagePath: 'assets/images/Picture4.png',
                    name: "Ayat SalahEldin",
                    jobTitle: 'Software Engineer',
                  ),
                  SizedBox(width: 20.sp),
                  TeamMemberCard(
                    imagePath: 'assets/images/Picture5.png',
                    name: "Ayat SalahEldin",
                    jobTitle: 'Software Engineer',
                  ),
                  SizedBox(width: 20.sp),
                  TeamMemberCard(
                    imagePath: 'assets/images/Picture6.png',
                    name: "Ayat SalahEldin",
                    jobTitle: 'Software Engineer',
                  ),
                ],
              ),
              //////////////////////////////
              ///our partners
              SizedBox(height: 150.sp),
              Text(
                "Our Partners",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 40.sp),
              Image.asset(
                'assets/images/Partners.png',
                height: 1563.sp,
                width: 1607.sp,
              ),
            ],
          ),

          // Join Us Section
          // Footer
          if (widget.tabController != null)
            Footer(tabController: widget.tabController!),
        ],
      ),
    );
  }
}
