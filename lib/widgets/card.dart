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
    return Stack(
      children: [
        Container(
          width: 450,
          height: 600,
          padding: EdgeInsets.all(
            20,
          ),
          decoration: BoxDecoration(
            color: WebsiteColors.whiteColor,
            borderRadius: BorderRadius.circular(
              15,
            ),
            boxShadow: [
              BoxShadow(
                color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
                blurRadius:
                    40,
                spreadRadius:
                   2
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: iconColor,
                child: Icon(
                  icon,
                  color: WebsiteColors.whiteColor,
                  size: 50,
                ),
              ),
              SizedBox(
               height:25
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.visionColor,
                  fontSize:
                     24
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
               height:10
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
        color: WebsiteColors.descGreyColor,
        fontWeight: FontWeight.w400,
                  fontSize:
                     18
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
