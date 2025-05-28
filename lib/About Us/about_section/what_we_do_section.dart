import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';

class WhatWeDoSection extends StatelessWidget {
  final AboutDataModel? aboutData;

  const WhatWeDoSection({Key? key, this.aboutData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            aboutData?.whatWeDoTitle ?? 'What We Do',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: WebsiteColors.primaryBlueColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 60),
          Container(
            constraints: BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        aboutData?.empowermentTitle ?? 'We empower engineering students',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: WebsiteColors.darkBlueColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        aboutData?.empowermentText ?? 'Through IEEE-led workshops, hands-on projects, and mentorship programs...',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
