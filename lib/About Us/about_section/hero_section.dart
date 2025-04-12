import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';

class HeroSection extends StatelessWidget {
  final AboutDataModel? aboutData;

  const HeroSection({Key? key, this.aboutData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            WebsiteColors.primaryBlueColor.withOpacity(0.7),
            WebsiteColors.darkBlueColor,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                aboutData?.heroSubtitle ?? 'ADDRESSING GLOBAL CHALLENGES',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: WebsiteColors.whiteColor.withOpacity(0.9),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20),
              Text(
                aboutData?.heroTitle ?? 'About IEEE PUA',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.whiteColor,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: WebsiteColors.whiteColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  aboutData?.heroHighlight ?? 'Advancing Technology for the Benefit of Humanity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: WebsiteColors.whiteColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}