import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 600 ? 8 : 10, horizontal:   MediaQuery.of(context).size.width < 600 ?10:20,),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [
                      WebsiteColors.primaryYellowColor,
                      const Color.fromARGB(255, 255, 230, 190),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(colors: [Colors.white, Colors.white]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: WebsiteColors.greyColor.withOpacity(0.1),
                blurRadius: 2,
                spreadRadius: 0.5,
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize:   MediaQuery.of(context).size.width < 600 ?12:16,
            fontWeight: FontWeight.bold,
            color:
                isSelected
                    ? WebsiteColors.darkGreyColor
                    : WebsiteColors.greyColor,
          ),
        ),
      ),
    );
  }
}
