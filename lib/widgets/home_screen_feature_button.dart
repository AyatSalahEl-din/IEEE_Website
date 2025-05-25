import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class HomeScreenFeatureButton extends StatefulWidget {
  final double left;
  final double top;
  final VoidCallback onTap;
  final Widget child;

  const HomeScreenFeatureButton({
    super.key,
    required this.left,
    required this.top,
    required this.onTap,
    required this.child,
  });

  @override
  _HomeScreenFeatureButtonState createState() =>
      _HomeScreenFeatureButtonState();
}

class _HomeScreenFeatureButtonState extends State<HomeScreenFeatureButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 360.sp,
            height: 140.sp,
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
            decoration: BoxDecoration(
              color: WebsiteColors.whiteColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20.sp),
              boxShadow: [
                BoxShadow(
                  color: WebsiteColors.whiteColor.withOpacity(
                    isHovered ? 0.8 : 0.1,
                  ),
                  blurRadius: isHovered ? 20.sp : 10.sp,
                  spreadRadius: isHovered ? 5.sp : 2.sp,
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
