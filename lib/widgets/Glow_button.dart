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
  @override
  Widget build(BuildContext context) {
    return widget.allEvents.length > 6
        ? Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.width > 600 ? 60.sp : 30.sp,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width > 600 ? 250.sp : 250.sp,
                MediaQuery.of(context).size.height > 600 ? 50.sp : 30.sp,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  30.sp,
                ), // Consistent rounding
              ),
              backgroundColor: WebsiteColors.primaryBlueColor,
            ),
            onPressed: widget.toggleItemsToShow,
            child: Center(
              child: Text(
                widget.itemsToShow >= widget.allEvents.length
                    ? "See Less"
                    : "See More",
                style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).size.width > 600 ? 18.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.whiteColor,
                ),
              ),
            ),
          ),
        )
        : const SizedBox.shrink();
  }
}
