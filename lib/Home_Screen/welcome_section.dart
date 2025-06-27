import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Widgets/text_gradeint.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 50.0,
        ), // Adjusted horizontal padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                FittedBox(
                  child: Text(
                    "Welcome to ",
                    style: GoogleFonts.poppins(
                      color: WebsiteColors.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 18 : 24,
                    ),
                    maxLines: null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            FittedBox(
              child: Text(
                "IEEE Pharos Student Branch",
                style: GoogleFonts.poppins(
                  color: WebsiteColors.darkBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 24,
                ),
                maxLines: null,
              ),
            ),
            SizedBox(height: 30.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "where innovation meets passion!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: WebsiteColors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 24,
                ),
                maxLines: null,
              ),
            ),
            SizedBox(height: 30.sp),
            Text(
              "At Pharos SB, we believe in empowering students to explore, create, and lead. Whether you're diving into cutting-edge projects, attending transformative events, or collaborating with like-minded peers, this is your space to grow and make an impact.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: WebsiteColors.darkGreyColor,
                fontWeight: FontWeight.w400,
                fontSize: isMobile ? 14 : 20,
              ),
              maxLines: null,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatBlock(context, "150", "Members"),
                SizedBox(
                  width: isMobile ? 60 : 120,
                ), // Adjusted spacing for mobile
                _buildStatBlock(context, "14", "Years"),
              ],
            ),
            SizedBox(height: 550.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBlock(BuildContext context, String value, String label) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: GradientText(
            text: value,
            style: GoogleFonts.abel(fontSize: isMobile ? 30: 60),
            gradient: LinearGradient(
              colors: [
                WebsiteColors.primaryBlueColor,
                WebsiteColors.gradeintBlueColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.alexandria(
            color: WebsiteColors.darkGreyColor,
            fontWeight: FontWeight.w400,
            fontSize: isMobile ? 18 : 24,
          ),
        ),
      ],
    );
  }
}
