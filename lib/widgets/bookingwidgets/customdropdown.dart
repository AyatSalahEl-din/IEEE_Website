import 'package:flutter/material.dart';
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
          12,
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          dropdownColor: Colors.white,
          hint: Text(
            hintText,
            style: TextStyle(
              color: WebsiteColors.greyColor,
              fontSize: 16,
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
            size: 24,
          ),
          style: TextStyle(
            color: WebsiteColors.greyColor,
            fontSize: 16,
            fontWeight: FontWeight.w100,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
