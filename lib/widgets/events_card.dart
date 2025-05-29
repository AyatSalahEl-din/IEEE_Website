import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'event_model.dart';
import 'event_details.dart';

class EventsCard extends StatefulWidget {
  final Event event;
  final TabController? tabController;

  // 🔹 Map for predefined event images (Fallback if Firestore image is missing)
  static const Map<String, List<String>> eventImageMap = {
    //"Egyptian Engineering Day": ["assets/images/201.jpg","assets/images/2020 2.jpg","assets/images/2024.jpg"],
    // "FOCUS": ["assets/images/FOCUS.jpg","assets/images/focus1.png","assets/images/focus2.png"],
    // "Introduction to Robotics Line Tracking": ["assets/images/2020 2.jpg","assets/images/2016.jpg","assets/images/2024.jpg"],
    //"Orientation Day": ["assets/images/OD1.jpg","assets/images/OD2.jpg","assets/images/OD7.jpg"
    //,"assets/images/OD3.jpg","assets/images/OD4.jpg","assets/images/OD5.jpg","assets/images/OD6.jpg",
    //],
    // "Recruitment 2016-2017(18-10-2016)":["assets/images/rec.jpg",
    //   "assets/images/recruitment1.jpg","assets/images/recruitment2.jpg",
    //   "assets/images/recruitment3.jpg","assets/images/recruitment4.jpg"
    // ],
    // "recruitment (19-4-2016)":["assets/images/rec2.jpg"],
    //"surrender the ME for the WE":["assets/images/surrender.jpg","assets/images/sur1.jpg","assets/images/sur2.jpg"],
    // "Photoshop workshop from zero to hero":["assets/images/workshop.jpg","assets/images/workshop1.jpg","assets/images/workshop2.jpg",
    //   "assets/images/workshop3.jpg","assets/images/workshop4.jpg","assets/images/workshop5.jpg",
    //   "assets/images/workshop6.jpg","assets/images/workshop7.jpg","assets/images/workshop8.jpg",
    //   "assets/images/workshop9.jpg","assets/images/workshop10.jpg"

    // ],
    // "ASPPC":["assets/images/ASPPC.jpg"],
    // "Black Seekers":["assets/images/BlackSeekers.jpg","assets/images/blackSeakers1.jpg",
    //   "assets/images/blackSeakers2.jpg","assets/images/blackSeakers3.jpg","assets/images/blackSeakers4.jpg","assets/images/blackSeakers5.jpg"
    // ],
    // "The Black Seekers Line Tracking Show":["assets/images/BlackSeekers2.png"],
    //"Career Debate": ["assets/images/CareerDebate.jpg","assets/images/careerDebate1.jpg","assets/images/careerDebate2.jpg"],
    // "Egyptian Engineering Day (EED) Visit":["assets/images/EED.jpg"],
    //"Get Hired":["assets/images/getHired.jpg"]
    // "Recruitment 2017":["assets/images/Recruitment2017.jpg"],
    // "Self-Development Awareness Session":["assets/images/volRec1.jpg","assets/images/volRec.jpg"],
    // "Insights from Industry Experts":["assets/images/careerDebateV2.jpg","assets/images/Insights from Industry Experts1.jpg","assets/images/Insights from Industry Experts2.jpg",
    //   "assets/images/Insights from Industry Experts3.jpg","assets/images/Insights from Industry Experts4.jpg"
    // ],
    // "Career Scope":["assets/images/careerScope.jpg"],
    // "Egyptian Engineering Day (EED)":["assets/images/EED18.jpg"],
    // "Sponsorship Letter Writing Workshop":["assets/images/FundRaisingWorkshop.jpg","assets/images/fundraising.jpg"],
    // "Mega Brain to be 18":["assets/images/MegaBrain.jpg","assets/images/megaBrain1.jpg","assets/images/megaBrain2.jpg"
    //   ,"assets/images/megaBrain3.jpg","assets/images/megaBrain4.jpg"],
    // "Know Your Committees":["assets/images/Know Your Committees.jpg","assets/images/Know Your Committees1.jpg","assets/images/Know Your Committees2.jpg",
    //   "assets/images/Know Your Committees3.jpg"],
    // "Mid-Year courses Registeration":["assets/images/Mid-year.jpg"],
    // "Blue Brain AI workshop":["assets/images/microsoft word1.jpg","assets/images/microsoft word2.jpg",
    //   "assets/images/microsoft word3.jpg","assets/images/microsoft word4.jpg","assets/images/microsoft word5.jpg",
    //   "assets/images/microsoft word6.jpg","assets/images/microsoft word7.jpg","assets/images/microsoft word8.jpg",
    //   "assets/images/microsoft word9.jpg","assets/images/microsoft word10.jpg","assets/images/Blue Brain.jpg"],

    // "AIESEC Alexandria ICX partnership":["assets/images/AIESEC.jpg"],
    // "Cairo ICT 2019":["assets/images/cairoICT1.jpg","assets/images/cairoICT.jpg"],
    // "Future X Camp Workshop":["assets/images/EYouth.jpg","assets/images/EYouth1.jpg","assets/images/EYouth2.jpg",
    //   "assets/images/EYouth3.jpg","assets/images/EYouth4.jpg","assets/images/EYouth5.jpg","assets/images/EYouth6.jpg",
    //   "assets/images/EYouth7.jpg","assets/images/EYouth8.jpg","assets/images/EYouth9.jpg","assets/images/EYouth10.jpg","assets/images/EYouth11.jpg",]
    // ,"IEEE PUA RAS Day":["assets/images/RAS0.jpg","assets/images/RAS.jpg","assets/images/RAS1.jpg","assets/images/RAS2.jpg","assets/images/RAS3.jpg"
    //   ,"assets/images/RAS4.jpg","assets/images/RAS5.jpg","assets/images/RAS6.jpg","assets/images/RAS7.jpg","assets/images/RAS8.jpg","assets/images/RAS9.jpg"
    //   ,"assets/images/RAS10.jpg","assets/images/RAS11.jpg","assets/images/RAS12.jpg","assets/images/RAS13.jpg","assets/images/RAS14.jpg","assets/images/RAS15.jpg"
    //   ,"assets/images/RAS16.jpg","assets/images/RAS17.jpg","assets/images/RAS18.jpg","assets/images/RAS19.jpg","assets/images/RAS20.jpg","assets/images/RAS21.jpg"]
    // ,"Leading Your Career 2019":["assets/images/leadingurcareer.jpg"]

    // "IBM Digital Nation Africa Innovation Tour":["assets/images/IBM3.jpg","assets/images/IBM2.jpg","assets/images/IBM1.jpg"],
  };

  const EventsCard({Key? key, required this.event, this.tabController})
    : super(key: key);

  @override
  _EventsCardState createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isClicked = true),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() => isClicked = false);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EventDetailsScreen(
                    event: widget.event,
                    tabController: widget.tabController,
                  ),
            ),
          );
        });
      },
      onTapCancel: () => setState(() => isClicked = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        transform:
            isClicked ? (Matrix4.identity()..scale(1.04)) : Matrix4.identity(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: WebsiteColors.lightGreyColor,
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
                    ),
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: _buildEventCardImage(),
                    ),
                  ),
                  Positioned(
                    bottom:
                        MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
                    left:
                        MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width > 600
                                ? 8.sp
                                : 6.sp,
                        vertical:
                            MediaQuery.of(context).size.width > 600
                                ? 4.sp
                                : 3.sp,
                      ),
                      decoration: BoxDecoration(
                        color: WebsiteColors.primaryYellowColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width > 600 ? 5.sp : 4.sp,
                        ),
                      ),
                      child: Text(
                        widget.event.category.isNotEmpty
                            ? widget.event.category
                            : "No Category",
                        style: TextStyle(
                          color: WebsiteColors.blackColor,
                          fontSize:
                              MediaQuery.of(context).size.width > 600
                                  ? 18.sp
                                  : 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
                    right:
                        MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
                    child: Icon(
                      widget.event.isOnlineEvent
                          ? Icons.wifi
                          : Icons.location_on,
                      color:
                          widget.event.isOnlineEvent
                              ? Colors.green
                              : Colors.blue,
                      size:
                          MediaQuery.of(context).size.width > 600
                              ? 24.sp
                              : 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Display First Image Only (Firebase or Local)
  Widget _buildEventCardImage() {
    List<String>? firebaseImages = widget.event.imageUrls;
    List<String>? localImages = EventsCard.eventImageMap[widget.event.name];
    String? firstImage;

    // ignore: unnecessary_null_comparison
    if (firebaseImages != null && firebaseImages.isNotEmpty) {
      firstImage = firebaseImages.first;
    } else if (localImages != null && localImages.isNotEmpty) {
      firstImage = localImages.first;
    }

    return firstImage != null
        ? firstImage.startsWith("http")
            ? Image.network(
              firstImage,
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 50.sp, color: Colors.grey),
            )
            : Image.asset(firstImage, width: double.infinity, fit: BoxFit.fill)
        : Icon(Icons.broken_image, size: 50.sp, color: Colors.grey);
  }
}
