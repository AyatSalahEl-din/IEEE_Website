import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/chatbot_widgets/preview_image_widget.dart';

import '../chatbot_models/message.dart';

class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: WebsiteColors.primaryBlueColor,
            borderRadius: BorderRadius.circular(60.sp),
          ),
          padding: EdgeInsets.all(30.sp),
          margin: EdgeInsets.only(bottom: 15.sp),
          child: Column(
            children: [
              if (message.imagesUrls.isNotEmpty)
                PreviewImagesWidget(
                  message: message,
                ),
              MarkdownBody(
                selectable: true,
                data: message.message.toString(),
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 40.sp, // Smaller text size
                    color: Colors.white, // Text color (change as needed)
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
