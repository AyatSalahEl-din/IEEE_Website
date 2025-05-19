import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';

class CommunityStatementSection extends StatelessWidget {
  final AboutDataModel? aboutData;

  const CommunityStatementSection({Key? key, this.aboutData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
      color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
      child: Container(
        constraints: BoxConstraints(maxWidth: 1200),
        child: Text(
          aboutData?.communityStatement ?? 'IEEE PUA SB represents more than just a student organization—it embodies a community of future tech leaders committed to innovation, professional excellence, and positive societal impact. Our members collaborate across disciplines to develop solutions for real-world challenges, gaining invaluable experience that prepares them for successful careers.',
          style: TextStyle(
            fontSize: 18,
            height: 1.7,
            color: WebsiteColors.darkBlueColor,
            letterSpacing: 0.2,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}