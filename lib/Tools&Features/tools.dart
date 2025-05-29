import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Tools&Features/proposal.dart';
import 'package:ieee_website/widgets/coming_soon_widget.dart';
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
            fontSize: 20.sp,
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
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.sp,
                          horizontal: 8.sp,
                        ),
                        child: _buildToolsContent(context),
                      ),
                    ),
                    if (tabController != null)
                      Footer(tabController: tabController!),
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
    bool noToolsAvailable = _checkToolsAvailability();

    if (noToolsAvailable) {
      return ComingSoonWidget(message: "No tools or features available yet!");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Text(
            'Discover the tools and features we offer to enhance your experience. Stay tuned for more exciting updates!',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 15.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: _buildSectionTitle('Available Tools'),
        ),
        SizedBox(height: 8.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: _buildToolCard(
            context: context,
            icon: FontAwesomeIcons.calendarCheck,
            title: 'Event Proposal',
            description: 'Submit your event ideas for collaboration.',
            color: WebsiteColors.primaryBlueColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventProposalForm(
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
        ),
        SizedBox(height: 15.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: _buildSectionTitle('Upcoming Features'),
        ),
        SizedBox(height: 8.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Column(
            children: [
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
                      builder: (context) => const ComingSoonWidget(
                        message: "Mobile App is coming soon!",
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.sp),
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
                      builder: (context) => const ComingSoonWidget(
                        message: "Chatbot is coming soon!",
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.sp),
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
                      builder: (context) => const ComingSoonWidget(
                        message: "Virtual Events Platform is coming soon!",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20.sp),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text(
              'Stay tuned for more updates!',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: WebsiteColors.primaryBlueColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.sp),
      ],
    );
  }

  bool _checkToolsAvailability() {
    List<String> availableTools = ["Event Proposal"];
    return availableTools.isEmpty;
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
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
      elevation: 4,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.sp),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  icon,
                  size: 20.sp,
                  color: color,
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: WebsiteColors.darkBlueColor,
                      ),
                    ),
                    SizedBox(height: 4.sp),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20.sp,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}