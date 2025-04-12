import 'package:flutter/material.dart';
import 'package:ieee_website/Widgets/footer.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/About Us/about_section/hero_section.dart';
import 'package:ieee_website/About Us/about_section/mission_section.dart';
import 'package:ieee_website/About Us/about_section/community_statement_section.dart';
import 'package:ieee_website/About Us/about_section/our_story_section.dart';
import 'package:ieee_website/About Us/about_section/what_we_do_section.dart';
import 'package:ieee_website/About Us/about_section/values_section.dart';
import 'package:ieee_website/About Us/services/about_data_service.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';

class AboutUs extends StatefulWidget {
  static const String routeName = 'aboutus';
  final TabController? tabController;

  const AboutUs({Key? key, this.tabController}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  // Data models
  AboutDataModel? _aboutData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    // Fetch data from Firebase
    _fetchAboutData();
  }

  Future<void> _fetchAboutData() async {
    try {
      final aboutData = await AboutDataService.fetchAllAboutData();

      setState(() {
        _aboutData = aboutData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
        _aboutData = AboutDataModel.fallback(); // Use fallback data
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: WebsiteColors.primaryBlueColor,
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            HeroSection(aboutData: _aboutData),

            // Mission Section
            MissionSection(aboutData: _aboutData),

            // Community Statement with Blue Background
            CommunityStatementSection(aboutData: _aboutData),

            // Our Story / History Section
            OurStorySection(),

            // What We Do Section
            WhatWeDoSection(aboutData: _aboutData),

            // Our Values Section with Icons
            ValuesSection(aboutData: _aboutData),

            // Imported Footer
            if (widget.tabController != null)
              Container(
                width: double.infinity,
                color: WebsiteColors.darkBlueColor.withOpacity(0.05),
                child: Footer(tabController: widget.tabController!),
              ),
          ],
        ),
      ),
    );
  }
}