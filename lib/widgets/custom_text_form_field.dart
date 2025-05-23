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
      maxLines: isMultiline ? null : 1, 
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: WebsiteColors.primaryBlueColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
        prefixIcon: Icon(icon, color: WebsiteColors.primaryBlueColor), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
      ),
      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
    );
  }
}
