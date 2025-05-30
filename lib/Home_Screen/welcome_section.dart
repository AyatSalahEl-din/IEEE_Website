import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Widgets/text_gradeint.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // ✅ 1. Wrap the entire content in SingleChildScrollView to handle vertical overflow.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  "Welcome to ",
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: null,
                ),
              ),

              Flexible(
                child: Text(
                  "IEEE Pharos Student Branch",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: WebsiteColors.darkBlueColor,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "where innovation meets passion!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
              maxLines: null,
            ),
          ),

          SizedBox(height: 30.sp),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Text(
              "At Pharos SB, we believe in empowering students to explore, create, and lead. Whether you're diving into cutting-edge projects, attending transformative events, or collaborating with like-minded peers, this is your space to grow and make an impact.",
              textAlign: TextAlign.center,
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleMedium, // 🎨 Keep original style
              maxLines: null,
            ),
          ),

          SizedBox(height: 50.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatBlock(context, "150", "Members"),
              SizedBox(width: 120.w),
              _buildStatBlock(context, "14", "Years"),
            ],
          ),

          SizedBox(height: 550.h),
        ],
      ),
    );
  }

  Widget _buildStatBlock(BuildContext context, String value, String label) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: GradientText(
            text: value,
            style: GoogleFonts.abel(fontSize: 120.sp),
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
        Text(label, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
