import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Home_Screen/url_helper.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class Footer extends StatelessWidget {
  final TabController tabController; // ✅ Accept TabController

  Footer({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ Gradient Background
        Container(
          height: 593.sp,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                WebsiteColors.primaryBlueColor.withOpacity(0.9),
                WebsiteColors.gradeintBlueColor.withOpacity(0.9),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        // ✅ Footer Content
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // IEEE Logo & Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/bluehoriz.png',
                    height: 300.sp,
                    width: 300.sp,
                  ),
                ],
              ),
              //SizedBox(height: 10.sp),

              // Newsletter Subscription
              Text(
                "Fuel your passion. Expand your network. Make an impact.",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                  color: WebsiteColors.primaryBlueColor,
                ),
              ),
              SizedBox(height: 10.sp),
              Text(
                "Join Us Now!",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                  color: WebsiteColors.primaryBlueColor,
                ),
              ),

              SizedBox(height: 20.sp),

              // ✅ Navigation Links (Clickable)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFooterNavItem(context, "About Us", 1), // Switch Tab
                  SizedBox(width: 20.sp),
                  _buildFooterNavItem(context, "Contact Us", 4), // Switch Tab
                  SizedBox(width: 20.sp),
                  _buildFooterNavItem(
                    context,
                    "Join Us",
                    null,
                  ), // ✅ Open New Page
                ],
              ),
              SizedBox(height: 10.sp),

              // ✅ Copyright
              Text(
                "© 2025 IEEE Pharos University's Web Team",
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(fontSize: 22.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Function to Handle Navigation
  Widget _buildFooterNavItem(BuildContext context, String text, int? tabIndex) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (text == "Join Us") {
            UrlHelper.fetchAndLaunchURL('joinUs');
          } else if (tabIndex != null) {
            // ✅ Switch Tab Normally
            tabController.animateTo(tabIndex);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: WebsiteColors.whiteColor,
              fontSize: 22.sp,
            ),
          ),
        ),
      ),
    );
  }
}
