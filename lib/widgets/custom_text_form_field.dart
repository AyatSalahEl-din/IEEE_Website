import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isMultiline;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isMultiline = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: isMultiline ? null : 1, // allows multiline if needed
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: WebsiteColors.primaryBlueColor,
          fontWeight: FontWeight.bold,
          fontSize: 25.sp,
        ),
        prefixIcon: Icon(icon, color: WebsiteColors.primaryBlueColor), // Custom icon color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: WebsiteColors.primaryBlueColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: WebsiteColors.primaryBlueColor, width: 2.0),
        ),
      ),
      style: TextStyle(fontSize: 31.sp),
    );
  }
}
