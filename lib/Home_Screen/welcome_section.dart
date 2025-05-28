import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Widgets/text_gradeint.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Welcome Text Row
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

        // Subtitle
        Text(
          "where innovation meets passion!",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        SizedBox(height: 30.sp),

        // Description Paragraph
        SizedBox(
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

        // Stats Row
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
    );
  }

  Widget _buildStatBlock(BuildContext context, String value, String label) {
    return Column(
      children: [
        GradientText(
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
        Text(label, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
