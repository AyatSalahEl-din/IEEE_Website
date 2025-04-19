import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';

class MissionSection extends StatelessWidget {
  final AboutDataModel? aboutData;

  const MissionSection({Key? key, this.aboutData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            aboutData?.missionTitle ?? 'Our Mission',
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
          SizedBox(height: 50),
          Container(
            constraints: BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Text(
                  aboutData?.missionParagraph1 ?? 'IEEE PUA Student Branch (SB) at Pharos University in Alexandria was established in 2014 as a premier platform for aspiring engineers, innovators, and technology enthusiasts. Our core mission is to bridge the gap between academic knowledge and industry requirements, creating an environment where technical skills, creative thinking, and leadership capabilities can flourish.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.7,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Text(
                  aboutData?.missionParagraph2 ?? 'We provide our members with comprehensive development through technical workshops, professional events, and hands-on project experiences. Our specialized committees span diverse technical domains including Artificial Intelligence, Data Science, Cybersecurity, and Robotics, offering targeted training programs and collaborative opportunities that translate theoretical concepts into practical applications.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.7,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}