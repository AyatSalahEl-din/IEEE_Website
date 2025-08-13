import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Home_Screen/url_helper.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  final TabController tabController;

  const Footer({super.key, required this.tabController});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                WebsiteColors.primaryBlueColor.withOpacity(0.98),
                WebsiteColors.gradeintBlueColor.withOpacity(0.95),
                WebsiteColors.primaryBlueColor.withOpacity(0.92),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile ? 14 : 40, // Reduced horizontal padding for mobile
              vertical:
                  isMobile ? 14 : 40, // Reduced vertical padding for mobile
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logos section
                _buildLogosSection(isMobile),

                SizedBox(
                  height: isMobile ? 8 : 18,
                ), // Reduced spacing for mobile
                // Motivation text
                _buildMotivationSection(isMobile),

                SizedBox(
                  height: isMobile ? 8 : 18,
                ), // Reduced spacing for mobile
                // Navigation links
                _buildNavigationSection(context, isMobile),

                SizedBox(
                  height: isMobile ? 8 : 18,
                ), // Reduced spacing for mobile
                // Social media section
                _buildSocialSection(),

                SizedBox(
                  height: isMobile ? 8 : 18,
                ), // Reduced spacing for mobile
                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: isMobile ? 12 : 20,
                ), // Reduced spacing for mobile
                // Copyright
                _buildCopyrightSection(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogosSection(bool isMobile) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                children: [
                  _buildAnimatedLogo(
                    'https://raw.githubusercontent.com/AyatSalahEl-din/IEEE_Images/refs/heads/main/ieeepua-logo.webp',
                    isMobile ? 24 : 40,
                  ),
                  _buildAnimatedLogo(
                    'https://raw.githubusercontent.com/AyatSalahEl-din/IEEE_Images/refs/heads/main/ieee-logo.webp',
                    isMobile ? 24 : 40,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo(String url, double height) {
    return MouseRegion(
      onEnter: (_) {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Image.network(
          url,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              width: height,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image,
                color: Colors.white.withOpacity(0.5),
                size: height * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMotivationSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.08),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.8),
                    Colors.white,
                  ],
                ).createShader(bounds),
            child: Text(
              "Expand your network. Make Impact.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 12 : 26,
                color: Colors.white,
                letterSpacing: 0.5,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Connect • Innovate • Lead",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: isMobile ? 12 : 16,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: isMobile ? 12 : 18,
        runSpacing: 12,
        children: [
          _buildEnhancedNavItem(context, "About Us", Icons.info_outline, 1),
          _buildEnhancedNavItem(
            context,
            "Contact Us",
            Icons.contact_mail_outlined,
            4,
          ),
          _buildEnhancedLinkItem(
            "Admin Site",
            Icons.supervisor_account,
            "https://ieeepuasb-admin.netlify.app/",
          ),
          _buildEnhancedLinkItem(
            "IEEE Official",
            Icons.language,
            "https://www.ieee.org/",
          ),

          _buildEnhancedJoinUsButton(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildEnhancedNavItem(
    BuildContext context,
    String text,
    IconData icon,
    int? tabIndex,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (tabIndex != null) widget.tabController.animateTo(tabIndex);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: WebsiteColors.primaryBlueColor, size: 14),
              const SizedBox(width: 6),
              Text(
                text,
                style: GoogleFonts.poppins(
                  color: WebsiteColors.primaryBlueColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedLinkItem(String label, IconData icon, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: WebsiteColors.primaryBlueColor, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: WebsiteColors.primaryBlueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedJoinUsButton(BuildContext context, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => UrlHelper.fetchAndLaunchURL('joinUs'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.group_add,
                color: WebsiteColors.primaryBlueColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                "Join Us",
                style: GoogleFonts.poppins(
                  color: WebsiteColors.primaryBlueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.08),
      ),
      child: Column(
        children: [
          Text(
            "Follow Us",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              _buildEnhancedSocialIcon(
                FontAwesomeIcons.linkedin,
                "https://www.linkedin.com/company/ieee-pua-student-branch/",
                Colors.blue[600]!,
              ),
              _buildEnhancedSocialIcon(
                FontAwesomeIcons.facebook,
                "https://m.facebook.com/people/Pharos-IEEE-SB/61572440826700/",
                Colors.blue[600]!,
              ),
              _buildEnhancedSocialIcon(
                FontAwesomeIcons.instagram,
                "https://www.instagram.com/ieeepua/",
                Colors.blue[600]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSocialIcon(
    IconData iconData,
    String url,
    Color accentColor,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: FaIcon(iconData, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildCopyrightSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Text(
        "© 2025 IEEE Pharos University's Web Team",
        style: GoogleFonts.poppins(
          fontSize: isMobile ? 12 : 14,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
