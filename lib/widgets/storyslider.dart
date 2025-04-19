import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:ieee_website/Themes/website_colors.dart';

class StorySlideshow extends StatefulWidget {
  @override
  _StorySlideshowState createState() => _StorySlideshowState();
}

class _StorySlideshowState extends State<StorySlideshow> {
  int currentIndex = 0;
  bool isHovered = false;
  late Timer _timer;

  final List<Map<String, String>> sliderItems = [
    {
      'image': 'assets/images/201.jpg',
      'description':
          'The IEEE Student Branch at Pharos University in Alexandria (PUA) was established in 2014 with the goal of enhancing the connection between engineering students and industry experts across Egypt. The branch aimed to provide students with valuable technical knowledge, networking opportunities, and hands-on experience in cutting-edge technologies.',
    },
    {
      'image': 'assets/images/2016 4.jpg',
      'description':
          'Over the past decade, IEEE PUA SB has organized numerous workshops, events, and projects that have significantly contributed to students technical and professional growth.',
    },
    {
      'image': 'assets/images/2016.jpg',
      'description':
          ' Some of our notable initiatives include:\n Workshops & Technical Sessions:\n•Blue Brain | AI Workshop(Dec 10, 2019)\n•MATLAB Workshops (2021)\n•Cybersecurity Event (2021)\n•Deep Fake Article (2021)',
    },
    {
      'image': 'assets/images/2018 2.jpg',
      'description':
          'Major Events & Conferences:\n•MEGA Brain To Be (2018)\n•Digital Nation Africa Innovation Tour (2019)\n•FutureX Program | IEEE PUA SB Camp (2019)\n•Zone X Digital - Maharat Min Google (2020)\n•IEEE PUA SB Magazine - Spatium (Aug 2020)\n•SYP R8 Congress 2022',
    },
    {
      'image': 'assets/images/2018 3.jpg',
      'description':
          'Conferences & Summits Attended:\n•Techne Summit Cairo (2022)\n•RiseUp Summit\n•IEEE Young Professionals Events',
    },
    {
      'image': 'assets/images/2020 2.jpg',
      'description':
          'IEEE PUA SB has collaborated with leading industry giants to provide students with high-quality resources and opportunities:\n-Egypt Makes Electronics\n-Electra   -Microsoft\n-Google   -Samsung\n-Coursera   -Robokid\n-IBM',
    },
    {
      'image': 'assets/images/2020.jpg',
      'description':
          'IEEE PUA SB is structured with a leadership team consisting of the Chair, Vice Chair, Secretary, and Treasurer. The branch is supported by key committees:\n•Public Relations (PR)   •Human Resources (HR)\n•Publicity\n•Technical Committee, which is divided into:\n-Web Development   -AI & Data Science\n-Robotics & Embedded Systems   -Cybersecurity',
    },
    {
      'image': 'assets/images/2024.jpg',
      'description':
          'For the 2024–2025 season, our focus is on driving technical projects and leveraging our committees to foster skill development. Our goal is to turn members’ weaknesses into strengths and transform strong skills into practical, impactful projects.',
    },
    {
      'image': 'assets/images/2022 2.jpg',
      'description':
          'Moving forward, IEEE PUA SB aims to:\n•Facilitate easier access to learning and growth opportunities for members.\n•Strengthen connections between students and industry experts.\n•Ensure a smooth handover and create a foundation for long-term stability and growth.',
    },
    {
      'image': 'assets/images/2022.jpg',
      'description':
          'IEEE PUA SB continues to be a hub of innovation and excellence, empowering students to become future leaders in engineering and technology.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startSlideshow();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!isHovered) {
        _nextSlide();
      }
    });
  }

  void _nextSlide() {
    setState(() {
      currentIndex = (currentIndex + 1) % sliderItems.length;
    });
  }

  void _prevSlide() {
    setState(() {
      currentIndex =
          (currentIndex - 1 + sliderItems.length) % sliderItems.length;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left Arrow
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: WebsiteColors.primaryBlueColor,
                    size: 30.sp,
                  ),
                  onPressed: _prevSlide,
                ),

                // Image & Description Side by Side
                Container(
                  width: 1500.w, // Total width of slideshow
                  height: 3000.h, // Ensure consistency in height
                  decoration: BoxDecoration(
                    color: WebsiteColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.sp),
                    boxShadow: [
                      BoxShadow(
                        color: WebsiteColors.gradeintBlueColor,
                        blurRadius: 10.sp,
                        spreadRadius: 3.sp,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Image Section
                      AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: ClipRRect(
                          key: ValueKey<int>(currentIndex),
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(12.sp),
                          ),
                          child: Image.asset(
                            sliderItems[currentIndex]['image']!,
                            fit: BoxFit.cover,
                            width: 800.w, // Half of the container width
                            height: 3000.w, // Full height of the container
                          ),
                        ),
                      ),

                      // Description Section
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: Text(
                            sliderItems[currentIndex]['description']!,
                            textAlign: TextAlign.start,
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              color: WebsiteColors.visionColor,
                              fontSize: 28.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Arrow
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: WebsiteColors.primaryBlueColor,
                    size: 30.sp,
                  ),
                  onPressed: _nextSlide,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
