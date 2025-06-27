import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Stack(
      children: [
        Container(
          width: isMobile ? 300 : 420, // Adjusted width for mobile
          height: isMobile ? 400 : 480, // Adjusted height for mobile
          padding: EdgeInsets.all(
            isMobile ? 20 : 30,
          ), // Adjusted padding for mobile
          decoration: BoxDecoration(
            color: WebsiteColors.whiteColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: isMobile ? 40 : 50, // Adjusted radius for mobile
                backgroundColor: iconColor,
                child: Icon(
                  icon,
                  color: WebsiteColors.whiteColor,
                  size: isMobile ? 40 : 50, // Adjusted icon size for mobile
                ),
              ),
              SizedBox(
                height: isMobile ? 20 : 25,
              ), // Adjusted spacing for mobile
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.visionColor,
                  fontSize: isMobile ? 16 : 20, // Adjusted font size for mobile
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: isMobile ? 8 : 10,
              ), // Adjusted spacing for mobile
              Text(
                description,
                style: GoogleFonts.poppins(
                  color: WebsiteColors.descGreyColor,
                  fontWeight: FontWeight.w400,
                  fontSize: isMobile ? 14 : 16, // Adjusted font size for mobile
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
