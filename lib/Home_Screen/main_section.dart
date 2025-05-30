import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Home_Screen/url_helper.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class MainSection extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/Picture1.png',
    'assets/images/Picture2.png',
    'assets/images/Picture3.png',
    'assets/images/Picture4.png',
    'assets/images/Picture5.png',
    'assets/images/Picture6.png',
  ];

  final VoidCallback onStoryTap;

  MainSection({super.key, required this.onStoryTap});

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double parentWidth = constraints.maxWidth;
        final double parentHeight = constraints.maxHeight;

        final double basePositionedLeft = 133.sp;
        final double basePositionedTop = 335.sp;
        final double baseDescriptionWidth = 803.sp;
        final double baseButtonWidth = 220.sp;
        final double baseButtonHeight = 80.sp;

        final double baseButtonSpacing = 20.sp;

        const double originalDesignWidthForScaling = 1920;
        const double originalDesignHeightForScaling = 6743;

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
                height: 1118.sp,
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
              height: 1118.sp,
              width: 1920.sp,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: gradient,
              ),
            ),

            Positioned(
              left: _getResponsiveDimension(
                parentWidth,
                basePositionedLeft,
                originalDesignWidthForScaling.sp,
              ),
              top: _getResponsiveDimension(
                parentHeight,
                basePositionedTop,
                originalDesignHeightForScaling.sp,
              ),

              width:
                  parentWidth -
                  _getResponsiveDimension(
                    parentWidth,
                    basePositionedLeft,
                    originalDesignWidthForScaling.sp,
                  ) -
                  20.w,
              child: Padding(
                //
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        "IEEE Pharos University in Alexandria",
                        style: Theme.of(context).textTheme.headlineLarge,
                        maxLines: null,
                      ),
                    ),

                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Where Innovation Meets Excellence",
                        style: Theme.of(context).textTheme.headlineMedium,
                        maxLines: null,
                      ),
                    ),
                    SizedBox(height: 20.sp),

                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: baseDescriptionWidth.clamp(
                          parentWidth * 0.7 - 40.w,
                          parentWidth - 40.w,
                        ),
                      ),
                      child: Text(
                        "Join us in shaping a future where technology and creativity unite, and where every member has the opportunity to thrive. Together, we’re not just building a community—we’re building a brighter tomorrow.",
                        style: Theme.of(context).textTheme.displayMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 20.sp),

                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WebsiteColors.primaryBlueColor,
                            foregroundColor: WebsiteColors.whiteColor,
                            fixedSize: Size(baseButtonWidth, baseButtonHeight),
                          ),
                          onPressed:
                              () => UrlHelper.fetchAndLaunchURL('joinUs'),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Join Us",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ),
                        SizedBox(width: baseButtonSpacing),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: WebsiteColors.whiteColor,
                            fixedSize: Size(baseButtonHeight, baseButtonHeight),
                          ),
                          onPressed: onStoryTap,
                          child: FittedBox(
                            child: Icon(
                              Icons.play_arrow,
                              color: WebsiteColors.primaryYellowColor,
                              size: 60.sp,
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
