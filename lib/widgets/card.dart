import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width > 600 ? 450.sp : 300.sp,
          height: MediaQuery.of(context).size.width > 600 ? 600.sp : 400.sp,
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 600 ? 20.sp : 15.sp,
          ),
          decoration: BoxDecoration(
            color: WebsiteColors.whiteColor,
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width > 600 ? 15.sp : 10.sp,
            ),
            boxShadow: [
              BoxShadow(
                color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
                blurRadius:
                    MediaQuery.of(context).size.width > 600 ? 40.sp : 20.sp,
                spreadRadius:
                    MediaQuery.of(context).size.width > 600 ? 2.sp : 1.sp,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width > 600 ? 50.sp : 35.sp,
                backgroundColor: iconColor,
                child: Icon(
                  icon,
                  color: WebsiteColors.whiteColor,
                  size: MediaQuery.of(context).size.width > 600 ? 50.sp : 35.sp,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width > 600 ? 25.sp : 15.sp,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.visionColor,
                  fontSize:
                      MediaQuery.of(context).size.width > 600 ? 24.sp : 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: WebsiteColors.descGreyColor,
                  fontSize:
                      MediaQuery.of(context).size.width > 600 ? 18.sp : 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
