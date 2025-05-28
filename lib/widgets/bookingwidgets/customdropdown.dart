import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 15.sp : 10.sp,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          dropdownColor: Colors.white,
          hint: Text(
            hintText,
            style: TextStyle(
              color: WebsiteColors.greyColor,
              fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
              fontWeight: FontWeight.w100,
              fontFamily: 'Poppins',
            ),
          ),
          iconEnabledColor: WebsiteColors.greyColor,
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: WebsiteColors.primaryBlueColor,
            size: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
          ),
          style: TextStyle(
            color: WebsiteColors.greyColor,
            fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
            fontWeight: FontWeight.w100,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
