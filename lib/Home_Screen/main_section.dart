import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Home_Screen/url_helper.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class MainSection extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/Picture1.png',
    'assets/images/Picture2.png',
    'assets/images/Picture3.png',
    'assets/images/Picture4.png',
    'assets/images/Picture5.png',
    'assets/images/Picture6.png',
  ];

  final VoidCallback onStoryTap;

  MainSection({super.key, required this.onStoryTap});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      bottomRight: Radius.elliptical(900.sp, 100.sp),
      bottomLeft: Radius.elliptical(900.sp, 100.sp),
    );

    final gradient = LinearGradient(
      colors: [
        WebsiteColors.primaryBlueColor.withOpacity(0.7),
        WebsiteColors.gradeintBlueColor.withOpacity(0.7),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Stack(
      children: [
        /// Background carousel
        CarouselSlider(
          options: CarouselOptions(
            height: 1118.sp,
            autoPlay: true,
            viewportFraction: 1.0,
          ),
          items:
              imageUrls
                  .map(
                    (imagePath) => ClipRRect(
                      borderRadius: borderRadius,
                      child: Image.asset(
                        imagePath,
                        width: 1920.sp,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  .toList(),
        ),

        /// Gradient overlay
        Container(
          height: 1118.sp,
          width: 1920.sp,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: gradient,
          ),
        ),

        /// Text and buttons
        Positioned(
          left: 133.sp,
          top: 335.sp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "IEEE Pharos University in Alexandria",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Where Innovation Meets Excellence",
                style: Theme.of(context).textTheme.headlineMedium,
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
                    onPressed: () => UrlHelper.fetchAndLaunchURL('joinUs'),
                    child: Text(
                      "Join Us",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(width: 20.sp),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: WebsiteColors.whiteColor,
                    ),
                    onPressed: onStoryTap,
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
      ],
    );
  }
}
