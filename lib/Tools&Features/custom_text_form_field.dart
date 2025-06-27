import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class CustomTextForm extends StatefulWidget {
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
  _CustomTextFormState createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.isMultiline ? (widget.maxLines ?? null) : (widget.obscureText ? 1 : (widget.maxLines ?? 1)),
      minLines: widget.isMultiline ? (widget.minLines ?? 3) : null,
      obscureText: widget.obscureText,
      onChanged: (value) {
        setState(() {
          _isWriting = value.isNotEmpty;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ?? TextStyle(color: WebsiteColors.greyColor, fontSize:MediaQuery.of(context).size.width < 600 ?12:16,),
        labelStyle: widget.labelStyle ?? TextStyle(color: WebsiteColors.primaryBlueColor, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width < 600 ?12:16,),
        prefixIcon: widget.icon != null ? Icon(widget.icon, color: WebsiteColors.primaryBlueColor, size: 24) : null,
        suffixIcon: widget.suffix,
        contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: WebsiteColors.primaryBlueColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: WebsiteColors.primaryBlueColor.withOpacity(0.7), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _isWriting ? Colors.blue : WebsiteColors.primaryBlueColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
      style: widget.textStyle ?? TextStyle(fontSize: MediaQuery.of(context).size.width < 600 ?12:16, color: Colors.black87),
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
    );
  }
}
