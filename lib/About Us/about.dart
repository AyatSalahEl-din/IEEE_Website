import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ieee_website/Widgets/footer.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AboutUs extends StatefulWidget {
  static const String routeName = 'aboutus';
  final TabController? tabController;

  const AboutUs({Key? key, this.tabController}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _isLoading = true;

  // Firebase data
  Map<String, dynamic> _aboutData = {};
  List<Map<String, dynamic>> _valuesData = [];
  String _videoUrl = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    // Fetch data from Firebase
    _fetchAboutData();
  }

  Future<void> _fetchAboutData() async {
    try {
      // Fetch main about data
      final aboutSnapshot = await FirebaseFirestore.instance
          .collection('about')
          .doc('main')
          .get();

      if (aboutSnapshot.exists) {
        setState(() {
          _aboutData = aboutSnapshot.data() ?? {};
        });
      }

      // Fetch values data
      final valuesSnapshot = await FirebaseFirestore.instance
          .collection('about')
          .doc('values')
          .collection('items')
          .get();

      final List<Map<String, dynamic>> valuesData = [];
      for (var doc in valuesSnapshot.docs) {
        valuesData.add(doc.data());
      }

      // Get video URL from Firebase Storage
      final videoRef = FirebaseStorage.instance.ref().child('videos/IEEE_Video.mp4');
      final videoUrl = await videoRef.getDownloadURL();

      setState(() {
        _valuesData = valuesData;
        _videoUrl = videoUrl;
        _isLoading = false;
      });

      // Initialize video controller with Firebase Storage URL
      _videoController = VideoPlayerController.network(_videoUrl)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        });

    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });

      // Fallback to asset video if Firebase fetch fails
      _videoController = VideoPlayerController.asset('assets/video/IEEE_Video.mp4')
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoController.dispose();
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
            // Hero Section (without world map image)
            Container(
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
                        _aboutData['heroSubtitle'] ?? 'ADDRESSING GLOBAL CHALLENGES',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: WebsiteColors.whiteColor.withOpacity(0.9),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _aboutData['heroTitle'] ?? 'About IEEE PUA',
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
                          _aboutData['heroHighlight'] ?? 'Advancing Technology for the Benefit of Humanity',
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
            ),

            // Mission Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    _aboutData['missionTitle'] ?? 'Our Mission',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: WebsiteColors.primaryBlueColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    constraints: BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        Text(
                          _aboutData['missionParagraph1'] ?? 'IEEE PUA Student Branch (SB) at Pharos University in Alexandria was established in 2014 as a premier platform for aspiring engineers, innovators, and technology enthusiasts. Our core mission is to bridge the gap between academic knowledge and industry requirements, creating an environment where technical skills, creative thinking, and leadership capabilities can flourish.',
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.7,
                            color: Colors.black87,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),
                        Text(
                          _aboutData['missionParagraph2'] ?? 'We provide our members with comprehensive development through technical workshops, professional events, and hands-on project experiences. Our specialized committees span diverse technical domains including Artificial Intelligence, Data Science, Cybersecurity, and Robotics, offering targeted training programs and collaborative opportunities that translate theoretical concepts into practical applications.',
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.7,
                            color: Colors.black87,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Community Statement with Blue Background
            Container(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
              color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                child: Text(
                  _aboutData['communityStatement'] ?? 'IEEE PUA SB represents more than just a student organization—it embodies a community of future tech leaders committed to innovation, professional excellence, and positive societal impact. Our members collaborate across disciplines to develop solutions for real-world challenges, gaining invaluable experience that prepares them for successful careers.',
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
            ),

            // Our Story / History Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    'Our Story',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: WebsiteColors.primaryBlueColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    constraints: BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // History heading
                        Text(
                          'IEEE PUA Student Branch History & Achievements',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: WebsiteColors.darkBlueColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        // Founding paragraph
                        Text(
                          'Founded in 2014, IEEE PUA SB was established with a clear vision: to enhance the connection between engineering students and industry experts across Egypt. Our goal has always been to provide valuable learning experiences, networking opportunities, and practical exposure to the latest technological advancements.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 30),
                        // Achievements section
                        Text(
                          'Key Achievements (2014–2024)',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: WebsiteColors.darkBlueColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Over the past decade, we have organized a series of transformative workshops, events, and collaborations that have significantly contributed to our members\' growth. Some of our most notable initiatives include:',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Achievement bullets
                        _buildAchievementPoint('AI & Cybersecurity Workshops', 'Covering topics like Blue Brain AI (2019), MATLAB applications (2021), and Cybersecurity awareness (2021).'),
                        SizedBox(height: 12),
                        _buildAchievementPoint('Technical Events & Conferences', 'Hosting MEGA Brain To Be \'18, participating in SYP R8 Congress 2022, and leading digital innovation initiatives like Zone X Digital - Maharat Min Google (2020).'),
                        SizedBox(height: 12),
                        _buildAchievementPoint('Industry Collaborations', 'Partnering with Microsoft, Google, IBM, Samsung, and Coursera to provide students with world-class resources and certifications.'),
                        SizedBox(height: 12),
                        _buildAchievementPoint('IEEE PUA SB Magazine – Spatium (2020)', 'The first IEEE PUA SB publication, offering deep insights into the latest tech trends.'),
                        SizedBox(height: 30),
                        // Current structure section
                        Text(
                          'Current Structure & Vision (2024-2025)',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: WebsiteColors.darkBlueColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'IEEE PUA SB operates through a well-structured leadership team and specialized committees, including AI & Data Science, Web Development, Robotics & Embedded Systems, Cybersecurity, and more. Our 2024-2025 focus is on driving impactful technical projects, mentoring students, and turning their skills into real-world solutions.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Looking ahead, we aim to expand learning opportunities, strengthen industry connections, and build a sustainable ecosystem where students can thrive. IEEE PUA SB is not just a place to learn—it\'s a place to innovate, collaborate, and lead. Be part of our journey toward technological excellence!',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // What We Do Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    _aboutData['whatWeDoTitle'] ?? 'What We Do',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: WebsiteColors.primaryBlueColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    constraints: BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Feature content
                        Container(
                          padding: EdgeInsets.all(24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _aboutData['empowermentTitle'] ?? 'We empower engineering students',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: WebsiteColors.darkBlueColor,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                _aboutData['empowermentText'] ?? 'Through IEEE-led workshops, hands-on projects, and mentorship programs, we help students develop practical skills that complement their academic education in electrical and electronic engineering.',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        // Video container
                        _buildVideoContainer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Our Values Section with Icons
            Container(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
              color: WebsiteColors.gradeintBlueColor.withOpacity(0.15),
              child: Column(
                children: [
                  Text(
                    _aboutData['valuesTitle'] ?? 'Our Values',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: WebsiteColors.darkBlueColor,
                    ),
                  ),
                  SizedBox(height: 60),
                  // Values with icons
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 50,
                    runSpacing: 40,
                    children: _valuesData.isNotEmpty
                        ? _valuesData.map((value) => _buildValueCard(
                      icon: _getIconData(value['icon'] ?? 'people'),
                      title: value['title'] ?? '',
                      description: value['description'] ?? '',
                    )).toList()
                        : [
                      _buildValueCard(
                        icon: Icons.people,
                        title: 'Collaboration',
                        description: 'Working together across IEEE disciplines to achieve common technological goals',
                      ),
                      _buildValueCard(
                        icon: Icons.lightbulb,
                        title: 'Innovation',
                        description: 'Constantly seeking creative solutions to engineering challenges through IEEE resources',
                      ),
                      _buildValueCard(
                        icon: Icons.trending_up,
                        title: 'Excellence',
                        description: 'Striving for the highest IEEE standards in all our technical endeavors',
                      ),
                    ],
                  ),
                ],
              ),
            ),

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

  // Helper method to build achievement bullet points
  Widget _buildAchievementPoint(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6, right: 10),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: WebsiteColors.primaryBlueColor,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title – ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Improved video container with better styling and initialization
  Widget _buildVideoContainer() {
    return GestureDetector(
      onTap: () {
        // Show improved video player when tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Container(
                width: 700,
                height: 400,
                child: Stack(
                  children: [
                    // Video player with black background
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: _isVideoInitialized
                          ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                          : Center(
                        child: CircularProgressIndicator(
                          color: WebsiteColors.primaryBlueColor,
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () {
                          _videoController.pause();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    // Play/Pause controls
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: StatefulBuilder(
                          builder: (context, setState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(
                                    _videoController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  label: Text(
                                      _videoController.value.isPlaying
                                          ? 'Pause'
                                          : 'Play'
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: WebsiteColors.primaryBlueColor,
                                    foregroundColor: Colors.white,
                                    elevation: 5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_videoController.value.isPlaying) {
                                        _videoController.pause();
                                      } else {
                                        _videoController.play();
                                      }
                                    });
                                  },
                                ),
                              ],
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: WebsiteColors.darkBlueColor.withOpacity(0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // IEEE logo as background for video thumbnail
            Positioned(
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.school,
                  size: 120,
                  color: WebsiteColors.darkBlueColor,
                ),
              ),
            ),
            // Video title
            Positioned(
              top: 20,
              child: Text(
                _aboutData['videoTitle'] ?? "IEEE PUA Student Branch",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.darkBlueColor,
                ),
              ),
            ),
            // Play button with gradient effect
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    WebsiteColors.primaryBlueColor,
                    WebsiteColors.primaryBlueColor.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: WebsiteColors.primaryBlueColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
            // "Watch video" text
            Positioned(
              bottom: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: WebsiteColors.darkBlueColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _aboutData['watchVideoText'] ?? "Watch IEEE Video",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build value cards with icons
  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: WebsiteColors.primaryBlueColor,
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper method to convert string to IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'people':
        return Icons.people;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'trending_up':
        return Icons.trending_up;
      case 'school':
        return Icons.school;
      case 'engineering':
        return Icons.engineering;
      case 'group_work':
        return Icons.group_work;
      default:
        return Icons.star; // Default icon
    }
  }
}