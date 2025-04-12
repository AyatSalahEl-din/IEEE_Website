import 'package:flutter/material.dart';

class IconHelper {
  /// Converts string icon name to Flutter's IconData
  static IconData getIconData(String iconName) {
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
      case 'code':
        return Icons.code;
      case 'security':
        return Icons.security;
      case 'laptop':
        return Icons.laptop;
      case 'build':
        return Icons.build;
      case 'business':
        return Icons.business;
      case 'psychology':
        return Icons.psychology;
      default:
        return Icons.star; // Default icon
    }
  }
}