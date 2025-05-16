import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart'; // Ensure correct path for your colors

import 'event_model.dart';

class GlowButton extends StatefulWidget {
  final int itemsToShow;
  final List<Event> allEvents;
  final VoidCallback toggleItemsToShow;

  const GlowButton({
    Key? key,
    required this.itemsToShow,
    required this.allEvents,
    required this.toggleItemsToShow,
  }) : super(key: key);

  @override
  _GlowButtonState createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _isButtonPressed = false;
  bool _isTransitioning = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: widget.allEvents.length > 6
          ? GestureDetector(
        onTap: () {
          setState(() {
            _isTransitioning = true;
            widget.toggleItemsToShow(); // Toggle the number of items shown
          });

          setState(() {
            _isButtonPressed = true;
          });

          // Reset the glowing effect after 300ms
          Future.delayed(Duration(milliseconds: 300), () {
            setState(() {
              _isButtonPressed = false;
              _isTransitioning = false;
            });
          });
        },
        child: AnimatedContainer(
          key: ValueKey(widget.itemsToShow),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                WebsiteColors.primaryBlueColor.withOpacity(0.8),
                WebsiteColors.primaryBlueColor.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            // Removed box shadow
            boxShadow: [],  // No shadow here
          ),
          child: Text(
            widget.itemsToShow >= widget.allEvents.length
                ? "See Less"
                : "See More",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              letterSpacing: 1.5,
              // Removed text shadow
            ),
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}