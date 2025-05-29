import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isMultiline;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isMultiline = false,
    this.validator,
    this.hintText,
    this.hintStyle,
    this.labelStyle,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: isMultiline ? null : 1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle:
            hintStyle ??
            TextStyle(
              color: WebsiteColors.greyColor,
              fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
            ),
        labelStyle:
            labelStyle ??
            TextStyle(
              color: WebsiteColors.primaryBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
            ),
        prefixIcon:
            // ignore: unnecessary_null_comparison
            icon != null
                ? Icon(
                  icon,
                  color: WebsiteColors.primaryBlueColor,
                  size: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
                )
                : null,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
              horizontal:
                  MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: BorderSide(color: WebsiteColors.primaryBlueColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor.withOpacity(0.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
        color: WebsiteColors.primaryBlueColor,
      ),
    );
  }
}
