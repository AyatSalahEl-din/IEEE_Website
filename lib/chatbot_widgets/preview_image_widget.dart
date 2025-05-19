import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../chatbot_models/message.dart';
import '../provider/chat_provider.dart';


class PreviewImagesWidget extends StatelessWidget {
  const PreviewImagesWidget({
    super.key,
    this.message,
  });

  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageToShow =
        message != null ? message!.imagesUrls : chatProvider.imagesFileList;
        final padding = message != null
            ? EdgeInsets.zero
            :  EdgeInsets.only(left: 8.0.sp, right: 8.0.sp);
        return Padding(
          padding: padding,
          child: SizedBox(
              height: 120.sp,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: messageToShow!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:  EdgeInsets.fromLTRB(
                        4.0.sp,
                        8.0.sp,
                        4.0.sp,
                        0.0.sp,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0.sp),
                        child: Image.file(

                          File(
                            message != null
                                ? message!.imagesUrls[index]
                                : chatProvider.imagesFileList![index].path,
                          ),
                          height: 100.sp,
                          width: 100.sp,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  })),
        );
      },
    );
  }
}