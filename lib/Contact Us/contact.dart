import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Widgets/footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact extends StatefulWidget {
  static const String routeName = 'contact';
  final TabController? tabController;
  const Contact({Key? key, this.tabController}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  int hoveredSocialIndex = -1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 800;

    return Scaffold(
      backgroundColor: WebsiteColors.whiteColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('contact_page')
            .doc('content')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildDefaultContactUI(isSmallScreen);
          }

          final contactData = snapshot.data!.data() as Map<String, dynamic>;
          return _buildContactUI(contactData, isSmallScreen);
        },
      ),
    );
  }

  Widget _buildDefaultContactUI(bool isSmallScreen) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 80),
            decoration: BoxDecoration(
              color: WebsiteColors.primaryBlueColor,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Contact Us",
                    style: TextStyle(
                      color: WebsiteColors.whiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "Fill up the form and our Team will get back to you",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: WebsiteColors.whiteColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildContactForm(isSmallScreen),
          _buildContactInfoSection(),
          if (widget.tabController != null)
            Container(
              width: double.infinity,
              color: WebsiteColors.darkBlueColor.withOpacity(0.05),
              child: Footer(tabController: widget.tabController!),
            ),
        ],
      ),
    );
  }

  Widget _buildContactUI(Map<String, dynamic> contactData, bool isSmallScreen) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 80),
            decoration: BoxDecoration(
              color: WebsiteColors.primaryBlueColor,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    contactData['headerTitle'] ?? "Contact Us",
                    style: TextStyle(
                      color: WebsiteColors.whiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      contactData['headerDescription'] ??
                          "Fill up the form and our Team will get back to you",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: WebsiteColors.whiteColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildContactForm(isSmallScreen),
          _buildContactInfoSection(contactData),
          if (widget.tabController != null)
            Container(
              width: double.infinity,
              color: WebsiteColors.darkBlueColor.withOpacity(0.05),
              child: Footer(tabController: widget.tabController!),
            ),
        ],
      ),
    );
  }

  Widget _buildContactForm(bool isSmallScreen) {
    return Container(
      constraints: BoxConstraints(maxWidth: 800),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: WebsiteColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSmallScreen
                ? _buildMobileFormFields()
                : _buildDesktopFormFields(),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: WebsiteColors.primaryBlueColor,
                  foregroundColor: WebsiteColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _handleMessageSubmit(),
                child: Text(
                  "Send Message",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection([Map<String, dynamic>? contactData]) {
    final emails = contactData?['emails'] as List<dynamic>? ??
        ['pua-ieee-sb@pua.edu.eg', 'ieee.pua.sb.pr@gmail.com'];
    final socialLinks = contactData?['socialLinks'] as Map<String, dynamic>? ?? {
      'facebook': 'https://www.facebook.com/share/1YKyPBgRVK/',
      'linkedin': 'https://www.linkedin.com/company/ieee-pua-student-branch/',
      'instagram': 'https://www.instagram.com/ieeepua?igsh=MWVla2RzbmJkNTZ5MQ==',
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: Colors.grey.shade100,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: WebsiteColors.primaryBlueColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      contactData?['address'] ?? "Pharos University in Alexandria (PUA)",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.email, color: WebsiteColors.primaryBlueColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email:",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5),
                        ...emails.asMap().entries.map((entry) {
                          int index = entry.key;
                          String email = entry.value.toString();
                          return Padding(
                            padding: EdgeInsets.only(bottom: 3),
                            child: InkWell(
                              onTap: () => _launchEmail(email),
                              child: Text(
                                "${index + 1}. $email",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: WebsiteColors.primaryBlueColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.public, color: WebsiteColors.primaryBlueColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Social Media:",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            _buildSocialIcon(0, FontAwesomeIcons.facebook, socialLinks['facebook']),
                            SizedBox(width: 15),
                            _buildSocialIcon(1, FontAwesomeIcons.linkedin, socialLinks['linkedin']),
                            SizedBox(width: 15),
                            _buildSocialIcon(2, FontAwesomeIcons.instagram, socialLinks['instagram']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField("Full Name", _nameController),
        SizedBox(height: 15),
        _buildInputField("Email Address", _emailController),
        SizedBox(height: 15),
        _buildInputField("Subject", _subjectController),
        SizedBox(height: 15),
        _buildInputField("Your Message", _messageController, maxLines: 4),
      ],
    );
  }

  Widget _buildDesktopFormFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInputField("Full Name", _nameController)),
            SizedBox(width: 15),
            Expanded(child: _buildInputField("Email Address", _emailController)),
          ],
        ),
        SizedBox(height: 15),
        _buildInputField("Subject", _subjectController),
        SizedBox(height: 15),
        _buildInputField("Your Message", _messageController, maxLines: 4),
      ],
    );
  }

  Widget _buildInputField(String placeholder, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 16 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: WebsiteColors.primaryBlueColor, width: 1),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(int index, IconData icon, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: WebsiteColors.primaryBlueColor,
          shape: BoxShape.circle,
        ),
        child: FaIcon(
          icon,
          color: WebsiteColors.whiteColor,
          size: 18,
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch email app'),
          backgroundColor: WebsiteColors.primaryBlueColor,
        ),
      );
    }
  }

  void _handleMessageSubmit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('contact_messages').add({
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your message has been sent!'),
          backgroundColor: WebsiteColors.primaryBlueColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
