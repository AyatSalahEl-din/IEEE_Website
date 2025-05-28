import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final double fontSize;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.fontSize = 14,
    this.obscureText = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        hintStyle: TextStyle(
          color: WebsiteColors.greyColor,
          fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
        ),
        labelStyle: TextStyle(
          color: WebsiteColors.primaryBlueColor,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: WebsiteColors.primaryBlueColor,
          size: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
          horizontal: MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
        color: Colors.black87,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}
