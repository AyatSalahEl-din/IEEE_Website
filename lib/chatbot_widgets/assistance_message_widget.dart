import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.all(30.sp),
          margin: EdgeInsets.only(bottom: 15.sp),
          child: message.isEmpty
              ?  SizedBox(
            width: 50,
            child: SpinKitThreeBounce(
              color: Colors.blueGrey,
              size: 40.0.sp,
            ),
          )
              : MarkdownBody(
            selectable: true,
            data: message,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 40.sp,
                color: WebsiteColors.darkGreyColor,
              ),
            ),

          )),
    );
  }
}