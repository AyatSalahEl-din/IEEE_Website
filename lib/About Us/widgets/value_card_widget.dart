import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class ValueCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const ValueCardWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              _getIconData(icon),
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
