import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class OurStorySection extends StatelessWidget {
  const OurStorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Our Story',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // History heading
                Text(
                  'IEEE PUA Student Branch History & Achievements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: WebsiteColors.darkBlueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Founding paragraph
                Text(
                  'Founded in 2014, IEEE PUA SB was established with a clear vision: to enhance the connection between engineering students and industry experts across Egypt. Our goal has always been to provide valuable learning experiences, networking opportunities, and practical exposure to the latest technological advancements.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30),
                // Achievements section
                Text(
                  'Key Achievements (2014–2024)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: WebsiteColors.darkBlueColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Over the past decade, we have organized a series of transformative workshops, events, and collaborations that have significantly contributed to our members\' growth. Some of our most notable initiatives include:',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                // Achievement bullets
                _buildAchievementPoint('AI & Cybersecurity Workshops', 'Covering topics like Blue Brain AI (2019), MATLAB applications (2021), and Cybersecurity awareness (2021).'),
                SizedBox(height: 12),
                _buildAchievementPoint('Technical Events & Conferences', 'Hosting MEGA Brain To Be \'18, participating in SYP R8 Congress 2022, and leading digital innovation initiatives like Zone X Digital - Maharat Min Google (2020).'),
                SizedBox(height: 12),
                _buildAchievementPoint('Industry Collaborations', 'Partnering with Microsoft, Google, IBM, Samsung, and Coursera to provide students with world-class resources and certifications.'),
                SizedBox(height: 12),
                _buildAchievementPoint('IEEE PUA SB Magazine – Spatium (2020)', 'The first IEEE PUA SB publication, offering deep insights into the latest tech trends.'),
                SizedBox(height: 30),
                // Current structure section
                Text(
                  'Current Structure & Vision (2024-2025)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: WebsiteColors.darkBlueColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'IEEE PUA SB operates through a well-structured leadership team and specialized committees, including AI & Data Science, Web Development, Robotics & Embedded Systems, Cybersecurity, and more. Our 2024-2025 focus is on driving impactful technical projects, mentoring students, and turning their skills into real-world solutions.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Looking ahead, we aim to expand learning opportunities, strengthen industry connections, and build a sustainable ecosystem where students can thrive. IEEE PUA SB is not just a place to learn—it\'s a place to innovate, collaborate, and lead. Be part of our journey toward technological excellence!',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build achievement bullet points
  Widget _buildAchievementPoint(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6, right: 10),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: WebsiteColors.primaryBlueColor,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title – ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}