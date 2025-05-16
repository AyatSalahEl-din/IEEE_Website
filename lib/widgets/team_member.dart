import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class TeamMemberCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String jobTitle;

  const TeamMemberCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.jobTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450.sp,
      height: 520.sp,
      decoration: BoxDecoration(
        color: WebsiteColors.whiteColor,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
            blurRadius: 40.sp,
            spreadRadius: 2.sp,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: Image.network(
              "$imagePath?timestamp=${DateTime.now().millisecondsSinceEpoch}", // Adds unique value to URL
              width: 430.sp,
              height: 400.sp,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print("Image Load Error: $imagePath"); // Debugging
                return Icon(Icons.error, color: Colors.red, size: 40);
              },
            ),
          ),
          SizedBox(height: 10.sp),
          Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: WebsiteColors.darkBlueColor,
            ),
          ),

          SizedBox(height: 10.sp),
          Text(
            jobTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 25.sp,
              color: WebsiteColors.visionColor,
            ),
          ),
        ],
      ),
    );
  }
}
