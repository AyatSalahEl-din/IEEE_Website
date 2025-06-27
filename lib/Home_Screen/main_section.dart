import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Home_Screen/url_helper.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class MainSection extends StatelessWidget {
  final List<String> imageUrls = [
    
    'assets/images/Picture2.png',
    'assets/images/Picture3.png',
    'assets/images/Picture1.png',
    'assets/images/Picture4.png',
    'assets/images/Picture5.png',
    'assets/images/Picture6.png',
  ];

  final VoidCallback onStoryTap;
  final TabController? tabController;

  MainSection({super.key, required this.onStoryTap, this.tabController});

  double _getResponsiveDimension(
    double currentDimension,
    double baseDimension,
    double originalDesignDimension,
  ) {
    double ratio = baseDimension / originalDesignDimension;
    double responsiveValue = currentDimension * ratio;
    return responsiveValue.clamp(baseDimension * 0.8, baseDimension);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double parentWidth = constraints.maxWidth;

        final double basePositionedLeft = isMobile ? 20.sp : 133.sp;
        final double basePositionedTop = isMobile ? 200.sp : 200.sp;
        final double baseDescriptionWidth =
            isMobile ? parentWidth - 40.sp : 803.sp;

        const double originalDesignWidthForScaling = 1920;

        final borderRadius = BorderRadius.only(
          bottomRight: Radius.elliptical(900.sp, 100.sp),
          bottomLeft: Radius.elliptical(900.sp, 100.sp),
        );

        final gradient = LinearGradient(
          colors: [
            WebsiteColors.primaryBlueColor.withOpacity(0.7),
            WebsiteColors.gradeintBlueColor.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

        return Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: isMobile ? 1200.sp : 900.sp,
                autoPlay: true,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              items:
                  imageUrls
                      .map(
                        (imagePath) => ClipRRect(
                          borderRadius: borderRadius,
                          child: Image.asset(
                            imagePath,
                            width: 1920.sp,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Text("Image Load Error"),
                                  ),
                                ),
                          ),
                        ),
                      )
                      .toList(),
            ),

            Container(
              height: isMobile ? 1200.sp : 900.sp,
              width: 1920.sp,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: gradient,
              ),
            ),

            Positioned(
              left: basePositionedLeft,
              top: basePositionedTop,
              width:
                  isMobile
                      ? parentWidth - 40.w
                      : parentWidth -
                          _getResponsiveDimension(
                            parentWidth,
                            basePositionedLeft,
                            originalDesignWidthForScaling.sp,
                          ) -
                          20.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        "IEEE Pharos University in Alexandria",
                        style: GoogleFonts.poppins(
                          color: WebsiteColors.darkGreyColor,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 28 : 40,
                        ),
                        maxLines: null,
                      ),
                    ),

                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Where Innovation Meets Excellence",
                        style: GoogleFonts.poppins(
                          color: WebsiteColors.darkGreyColor,
                          fontWeight: FontWeight.w400,
                          fontSize: isMobile ? 28 : 40,
                        ),
                        maxLines: null,
                      ),
                    ),
                    SizedBox(height: 20.sp),

                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: baseDescriptionWidth.clamp(
                          parentWidth * 0.68 - 40.w,
                          parentWidth - 40.w,
                        ),
                      ),
                      child: Text(
                        "Join us in shaping a future where technology and creativity unite, and where every member has the opportunity to thrive.",
                        style: GoogleFonts.poppins(
                          color: WebsiteColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: isMobile ? 14 : 22,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 20.sp),

                    // Buttons section - different layout for mobile
                    if (isMobile)
                      // Mobile layout: 3 feature icons without play button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (tabController != null) {
                                tabController!.animateTo(2); // Events tab
                              }
                            },
                            child: Container(
                              width: 130.sp,
                              height: 130.sp,
                              decoration: BoxDecoration(
                                color: WebsiteColors.primaryBlueColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: WebsiteColors.whiteColor,
                                size: 20,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              if (tabController != null) {
                                tabController!.animateTo(5); // Features tab
                              }
                            },
                            child: Container(
                              width: 130.sp,
                              height: 130.sp,
                              decoration: BoxDecoration(
                                color: WebsiteColors.visionColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                color: WebsiteColors.whiteColor,
                                size: 20,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              if (tabController != null) {
                                tabController!.animateTo(3); // Papers tab
                              }
                            },
                            child: Container(
                              width: 130.sp,
                              height: 130.sp,
                              decoration: BoxDecoration(
                                color: WebsiteColors.primaryYellowColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lightbulb,
                                color: WebsiteColors.whiteColor,
                                size: 20,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (onStoryTap != null) {
                                onStoryTap(); // Navigate to the story section
                              }
                            },
                            child: Container(
                              width: 130.sp,
                              height: 130.sp,
                              decoration: BoxDecoration(
                                color: WebsiteColors.whiteColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: WebsiteColors.primaryYellowColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      // Desktop layout: original buttons with play button
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WebsiteColors.primaryBlueColor,
                              foregroundColor: WebsiteColors.whiteColor,
                              fixedSize: Size(160, 80),
                            ),
                            onPressed:
                                () => UrlHelper.fetchAndLaunchURL('joinUs'),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Join Us",
                                style: GoogleFonts.poppins(
                                  color: WebsiteColors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: WebsiteColors.whiteColor,
                              fixedSize: Size(80, 80),
                            ),
                            onPressed: onStoryTap,
                            child: Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: WebsiteColors.primaryYellowColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
