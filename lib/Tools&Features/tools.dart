import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Tools&Features/proposal.dart'; // Import the Event Proposal page
import 'package:ieee_website/Tools&Features/ai.dart';
import 'package:ieee_website/widgets/coming_soon_widget.dart'; // Import the AI Tool page

class Tools extends StatelessWidget {
  static const String routeName = 'tools';
  final TabController? tabController;

  const Tools({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WebsiteColors.whiteColor,
      appBar: AppBar(
        title: Text(
          'Our Tools & Features',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: WebsiteColors.primaryBlueColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 16.sp),
        child: _buildToolsContent(context), // Pass context here
      ),
    );
  }

  Widget _buildToolsContent(BuildContext context) {
    // Replace with actual logic to check availability
    bool noToolsAvailable = _checkToolsAvailability();

    if (noToolsAvailable) {
      return ComingSoonWidget(message: "No tools or features available yet!");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Explore Our Tools',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
        ),
        SizedBox(height: 20.sp),
        Text(
          'Discover the tools and features we offer to enhance your experience. Stay tuned for more exciting updates!',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.sp),

        // Tools Section
        _buildSectionTitle('Available Tools'),
        SizedBox(height: 16.sp),
        _buildToolCard(
          context: context,
          icon: FontAwesomeIcons.calendarCheck,
          title: 'Event Proposal',
          description: 'Submit your event ideas for collaboration.',
          color: WebsiteColors.primaryBlueColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EventProposalForm(
                      formKey: GlobalKey<FormState>(),
                      eventNameController: TextEditingController(),
                      organizerNameController: TextEditingController(),
                      companyNameController: TextEditingController(),
                      emailController: TextEditingController(),
                      phoneController: TextEditingController(),
                      eventDescriptionController: TextEditingController(),
                      expectedAttendeesController: TextEditingController(),
                      proposedDateController: TextEditingController(),
                      proposedLocationController: TextEditingController(),
                      ieeeBenefitsController: TextEditingController(),
                      additionalNotesController: TextEditingController(),
                      submitProposal: () {
                        // Add your submit logic here
                      },
                      isLoading: false,
                    ),
              ),
            );
          },
        ),
        _buildToolCard(
          context: context,
          icon: FontAwesomeIcons.robot,
          title: 'AI Tool',
          description: 'Leverage AI to enhance your productivity.',
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AIToolPage()),
            );
          },
        ),
        SizedBox(height: 30.sp),

        // Upcoming Features Section
        _buildSectionTitle('Upcoming Features'),
        SizedBox(height: 16.sp),
        _buildToolCard(
          context: context,
          icon: FontAwesomeIcons.mobileAlt,
          title: 'Mobile App',
          description: 'Access all features on the go.',
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const ComingSoonWidget(
                      message: "Mobile App is coming soon!",
                    ),
              ),
            );
          },
        ),
        _buildToolCard(
          context: context,
          icon: FontAwesomeIcons.video,
          title: 'Virtual Events Platform',
          description: 'Attend events from anywhere.',
          color: Colors.purple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const ComingSoonWidget(
                      message: "Virtual Events Platform is coming soon!",
                    ),
              ),
            );
          },
        ),
        SizedBox(height: 30.sp),

        Center(
          child: Text(
            'Stay tuned for more updates!',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.primaryBlueColor,
            ),
          ),
        ),
      ],
    );
  }

  bool _checkToolsAvailability() {
    // Replace this with actual logic to determine if tools are available
    // For example, check if a list of tools is empty
    List<String> availableTools = [
      "Event Proposal",
      "AI Tool",
    ]; // Example tools
    return availableTools.isEmpty;
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: WebsiteColors.darkBlueColor,
      ),
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      color: Colors.white, // Set card background to white
      margin: EdgeInsets.only(bottom: 20.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.sp),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(icon, size: 28.sp, color: color),
              ),
              SizedBox(width: 16.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: WebsiteColors.darkBlueColor,
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
