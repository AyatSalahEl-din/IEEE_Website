import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'event_details.dart';
import 'package:ieee_website/widgets/event_model.dart';

class EventsCard extends StatefulWidget {
  final Event event;
  final TabController? tabController;

  const EventsCard({Key? key, required this.event, this.tabController}) : super(key: key);

  @override
  _EventsCardState createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isClicked = true;
        });
      },
      onTapUp: (_) {
        Future.delayed(Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              isClicked = false;
            });
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(
                event: widget.event,
                tabController: widget.tabController,
              ),
            ),
          );
        });
      },
      onTapCancel: () {
        setState(() {
          isClicked = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds:300),
        curve: Curves.fastOutSlowIn,
        transform: isClicked
            ? (Matrix4.identity()..scale(1.09)) // Shrink on click
            : Matrix4.identity(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Container(
                  height: 300.sp,
                  width: 500.sp,
                  decoration: BoxDecoration(
                    color: WebsiteColors.lightGreyColor,
                    borderRadius: BorderRadius.circular(10.sp),
                    image: DecorationImage(
                      image: AssetImage(widget.event.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(

                  bottom: 10.sp,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                    decoration: BoxDecoration(
                      color: WebsiteColors.primaryYellowColor,
                      borderRadius: BorderRadius.circular(5.sp),
                    ),
                    child: Text(
                      widget.event.category,
                      style: TextStyle(color: WebsiteColors.blackColor, fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                text: '${widget.event.month} ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: WebsiteColors.primaryBlueColor,
                  fontSize: 20.sp,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.event.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: WebsiteColors.darkBlueColor,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Location: ${widget.event.location}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: WebsiteColors.blackColor,
                fontSize: 18.sp,
              ),
            ),
            Text(
              "Time: ${widget.event.time}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: WebsiteColors.blackColor,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
