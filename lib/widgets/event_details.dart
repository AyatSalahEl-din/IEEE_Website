import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'event_model.dart';
import '../../Themes/website_colors.dart';
import 'footer.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final TabController? tabController;

  const EventDetailsScreen({Key? key, required this.event, this.tabController}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        title: Text(widget.event.name, style: TextStyle(color: WebsiteColors.whiteColor,fontSize: 35.sp)),
    centerTitle: true,
    leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.of(context).pop(),

      ),),
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 70.sp, vertical: 70.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Event Image + Name Section
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: WebsiteColors.whiteColor,
                      borderRadius: BorderRadius.circular(20.sp),
                      border: Border.all(
                        color: WebsiteColors.greyColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  Event Image + Time & Location (LEFT SIDE)
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.sp)),
                              child: Image.asset(
                                widget.event.imageUrl,
                                // height: height * 0.5,
                                width: width * 0.5,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(height: 35.sp),

                            //  Time (Below Image)
                            Row(
                              children: [
                                Icon(Icons.timelapse_outlined, color: WebsiteColors.primaryBlueColor),
                                SizedBox(width: 8.sp),
                                Text(
                                  "Time: ${widget.event.time}",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WebsiteColors.primaryBlueColor,
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.sp),

                            // 📍 Location (Below Image)
                            Row(
                              children: [
                                Icon(Icons.location_on, color: WebsiteColors.primaryBlueColor),
                                SizedBox(width: 8.sp),
                                Text(
                                  "Location: ${widget.event.location}",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WebsiteColors.primaryBlueColor,
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp),
                          ],
                        ),
                        SizedBox(width: 20),

                        // 📌 Event Name + Tags (RIGHT SIDE)
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.symmetric(vertical: 40.sp, horizontal: 20.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 📆 Month + Day
                                Text(
                                  "${widget.event.month} ${widget.event.date.split('-')[2]}", // Extract day from date
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WebsiteColors.primaryBlueColor,
                                    fontSize: 35.sp,
                                  ),
                                ),
                                SizedBox(height: 15.sp),

                                // 🏷️ Event Name
                                Text(
                                  widget.event.name,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WebsiteColors.darkBlueColor,
                                    fontSize: 35.sp,
                                  ),
                                ),
                                SizedBox(height: 35.sp),

                                // 🏷️ Hosted By
                                Text(
                                  "by ${widget.event.hostName}",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: WebsiteColors.blackColor,
                                    fontSize: 30.sp
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),

                  ),

                  SizedBox(height: 70.sp),

                  // 📌 Event Details Section
                  Text(
                    'Details',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: WebsiteColors.darkBlueColor,
                      fontSize: 40.sp,
                    ),
                  ),
                  Text(
                    widget.event.details,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                      fontSize: 30.sp,
                    ),
                  ),
                  SizedBox(height: 50.sp),

                  // 📌 Hosted By Section
                  Text(
                    'Hosted By',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: WebsiteColors.darkBlueColor,
                      fontSize: 40.sp,
                    ),
                  ),
                  Text(
                    widget.event.hostedBy,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: WebsiteColors.primaryBlueColor,
                      fontSize: 30.sp,
                    ),
                  ),

                  SizedBox(height: 50.sp),
                ],
              ),
            ),

          ),
// ✅ Footer Section (Added Outside ScrollView)
          if (widget.tabController != null) Footer(tabController: widget.tabController!),

        ],
      ),
    );
  }
}
