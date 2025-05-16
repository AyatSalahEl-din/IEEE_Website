import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected; // Callback function for onSelected

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth; // Get screen width

    return Padding(
      padding: EdgeInsets.only(right: screenWidth < 400 ? 4.sp : 8.sp), // Adjust right padding
      child: FilterChip(
        label: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 400 ? 1 : 6.sp, // Adjust padding for better fit
            vertical: screenWidth < 400 ? .5 : 2.sp,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? WebsiteColors.whiteColor : WebsiteColors.blackColor, // Change text color based on selection
              fontSize: screenWidth < 400 ? 20.sp : 20.sp, // Scale text size
            ),
          ),
        ),
        backgroundColor: isSelected ? WebsiteColors.primaryBlueColor : Colors.white, // Change background color when selected
        shape: StadiumBorder(
          side: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: screenWidth < 400 ? 1.sp : 2.sp, // Reduce border thickness
          ),
        ),
        selected: isSelected, // Pass selected state
        onSelected: (_) => onSelected(), // Call the onSelected callback when clicked
      ),
    );
  }
}