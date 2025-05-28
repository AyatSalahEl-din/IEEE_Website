import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Tools&Features/proposal.dart'; // Import the Event Proposal page
import 'package:ieee_website/widgets/coming_soon_widget.dart'; // Import the AI Tool page
import 'package:ieee_website/widgets/footer.dart';

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
            fontSize:
                MediaQuery.of(context).size.width > 600
                    ? 24.sp
                    : 18.sp, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: WebsiteColors.primaryBlueColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical:
                            MediaQuery.of(context).size.width > 600
                                ? 20.sp
                                : 10.sp,
                        horizontal:
                            MediaQuery.of(context).size.width > 600
                                ? 16.sp
                                : 8.sp,
                      ),
                      child: _buildToolsContent(context),
                    ),
                    const Spacer(), // Push footer to the bottom
                    if (tabController != null)
                      Footer(
                        tabController: tabController!,
                      ), // Footer at the bottom
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolsContent(BuildContext context) {
    bool noToolsAvailable = _checkToolsAvailability(context);

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
              fontSize:
                  MediaQuery.of(context).size.width > 600
                      ? 28.sp
                      : 20.sp, // Responsive font size
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
        ),
        Text(
          'Discover the tools and features we offer to enhance your experience. Stay tuned for more exciting updates!',
          style: TextStyle(
            fontSize:
                MediaQuery.of(context).size.width > 600
                    ? 16.sp
                    : 12.sp, // Responsive font size
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 30.sp : 15.sp,
        ),
        _buildSectionTitle(context, 'Available Tools'),
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 16.sp : 8.sp,
        ),
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

        _buildSectionTitle(context, 'Upcoming Features'),
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 16.sp : 8.sp,
        ),
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
          icon: FontAwesomeIcons.comments,
          title: 'Chatbot',
          description: 'Get instant assistance with our chatbot.',
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const ComingSoonWidget(
                      message: "Chatbot is coming soon!",
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
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 30.sp : 15.sp,
        ),
        Center(
          child: Text(
            'Stay tuned for more updates!',
            style: TextStyle(
              fontSize:
                  MediaQuery.of(context).size.width > 600
                      ? 18.sp
                      : 14.sp, // Responsive font size
              fontWeight: FontWeight.bold,
              color: WebsiteColors.primaryBlueColor,
            ),
          ),
        ),
      ],
    );
  }

  bool _checkToolsAvailability(BuildContext context) {
    List<String> availableTools = ["Event Proposal"];
    return availableTools.isEmpty;
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize:
            MediaQuery.of(context).size.width > 600
                ? 22.sp
                : 18.sp, // Responsive font size
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
      color: Colors.white,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 600 ? 16.sp : 8.sp,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  icon,
                  size:
                      MediaQuery.of(context).size.width > 600
                          ? 28.sp
                          : 20.sp, // Responsive icon size
                  color: color,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 600 ? 16.sp : 8.sp,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 600
                                ? 18.sp
                                : 14.sp, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: WebsiteColors.darkBlueColor,
                      ),
                    ),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.width > 600 ? 8.sp : 4.sp,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 600
                                ? 14.sp
                                : 12.sp, // Responsive font size
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
