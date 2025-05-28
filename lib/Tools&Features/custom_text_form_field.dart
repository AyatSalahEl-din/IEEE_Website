import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool isMultiline;
  final bool obscureText;
  final bool readOnly;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final Widget? suffix;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextForm({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.isMultiline = false,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.suffix,
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines:
          isMultiline
              ? (maxLines ?? null)
              : (obscureText ? 1 : (maxLines ?? 1)),
      minLines: isMultiline ? (minLines ?? 3) : null,
      obscureText: obscureText,
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
            icon != null
                ? Icon(
                  icon,
                  color: WebsiteColors.primaryBlueColor,
                  size: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
                )
                : null,
        suffixIcon: suffix,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
              horizontal:
                  MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
          ),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: MediaQuery.of(context).size.width > 600 ? 1.5.sp : 1.0.sp,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
          ),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor.withOpacity(0.7),
            width: MediaQuery.of(context).size.width > 600 ? 1.5.sp : 1.0.sp,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
          ),
          borderSide: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: MediaQuery.of(context).size.width > 600 ? 2.0.sp : 1.5.sp,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: MediaQuery.of(context).size.width > 600 ? 1.5.sp : 1.0.sp,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
          ),
          borderSide: BorderSide(
            color: Colors.red.shade700,
            width: MediaQuery.of(context).size.width > 600 ? 2.0.sp : 1.5.sp,
          ),
        ),
      ),
      style:
          textStyle ??
          TextStyle(
            fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
            color: Colors.black87,
          ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
