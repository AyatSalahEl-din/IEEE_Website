import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: 60,
            height: 3,
            color: WebsiteColors.primaryYellowColor,
          ),
        ],
      ),
    );
  }
}

