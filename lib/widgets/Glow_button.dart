import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class GlowButton extends StatelessWidget {
  final int itemsToShow;
  final List<dynamic> allEvents;
  final VoidCallback toggleItemsToShow;

  const GlowButton({
    super.key,
    required this.itemsToShow,
    required this.allEvents,
    required this.toggleItemsToShow,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(250, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: WebsiteColors.primaryBlueColor,
        foregroundColor: WebsiteColors.whiteColor,
      ),
      onPressed: toggleItemsToShow,
      child: Text(
        itemsToShow >= allEvents.length ? "See Less" : "See More",
        style: TextStyle(fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

