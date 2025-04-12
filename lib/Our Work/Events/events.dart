import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/widgets/event_grid.dart';
import 'package:ieee_website/widgets/footer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Themes/website_colors.dart';
import '../../widgets/filter_chip_widget.dart';

class Events extends StatefulWidget {
  static const String routeName = 'events';
  final TabController? tabController;

  const Events({super.key, this.tabController});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void _launchURL() async {
      final Uri url = Uri.parse("https://www.linkedin.com/in/menna-allah-rabei-a3565131a/");
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception("Could not launch $url");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Expanded(
        child: ListView(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 1118.sp,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/Mask group.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 400.sp,
                        right: 200.sp,
                        top: 400.sp,
                        bottom: 500.sp,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        decoration: BoxDecoration(
                          color: WebsiteColors.whiteColor,
                          borderRadius: BorderRadius.circular(50.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.sp,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Events, Categories, Location...",
                            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: WebsiteColors.lightGreyColor),
                            prefixIcon: Icon(Icons.search, color: WebsiteColors.darkGreyColor, size: 25.sp),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImageIcon(
                                  AssetImage("assets/images/location_icon.png"),
                                  color: WebsiteColors.darkGreyColor,
                                ),
                                SizedBox(width: 5.sp),
                                Text(
                                  "Location",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: WebsiteColors.darkGreyColor),
                                ),
                                Icon(Icons.arrow_drop_down, color: WebsiteColors.darkGreyColor),
                                SizedBox(width: 10.sp),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: 500.sp,
                        right: 200.sp,
                        top: 550.sp,
                        bottom: 500.sp,
                      ),
                      child: Text(
                        "Don't miss out! Explore our events.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.sp),

                // Upcoming Events
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Events",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: WebsiteColors.primaryBlueColor,
                          fontSize: 40.sp,
                        ),
                      ),
                      SizedBox(height: 25.sp),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FilterChipWidget(label: "All"),
                          FilterChipWidget(label: "Today"),
                          FilterChipWidget(label: "This Week"),
                          FilterChipWidget(label: "This Month"),
                        ],
                      ),

                      SizedBox(height: 30.sp),
                      EventsGrid(filterType: "upcoming"),
                      SizedBox(height: 45.sp),

                      // Book Your Seat Section
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.sp),
                            child: Container(
                              height: 430.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.sp),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/book_your_seat.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20.sp),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(80.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Secure your Spot",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WebsiteColors.darkBlueColor,
                                    fontSize: 38.sp,
                                  ),
                                ),
                                SizedBox(height: 10.sp),
                                Text(
                                  "Empowering Ideas, Connecting Minds",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: WebsiteColors.whiteColor,
                                    fontSize: 36.sp,
                                  ),
                                ),
                                SizedBox(height: 5.sp),
                                Text(
                                  "Seamless Booking for Every Event!",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: WebsiteColors.whiteColor,
                                    fontSize: 36.sp,
                                  ),
                                ),
                                SizedBox(height: 20.sp),
                                ElevatedButton(
                                  onPressed: _launchURL,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: WebsiteColors.primaryYellowColor,
                                    textStyle: const TextStyle(color: WebsiteColors.darkBlueColor),
                                    padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 6.sp),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.sp),
                                    ),
                                  ),
                                  child: Text(
                                    "Book Your Seat",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: WebsiteColors.darkBlueColor,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.sp),

                      // Previous Events
                      Text(
                        "Previous Events",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: WebsiteColors.primaryBlueColor,
                          fontSize: 40.sp,
                        ),
                      ),
                      SizedBox(height: 15.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FilterChipWidget(label: "All"),
                          FilterChipWidget(label: "Today"),
                          FilterChipWidget(label: "This Week"),
                          FilterChipWidget(label: "This Month"),
                        ],
                      ),
                      SizedBox(height: 30.sp),
                      EventsGrid(filterType: "previous"),

                      SizedBox(height: 30.sp),



                      SizedBox(height: 20.sp),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.tabController != null)
              Footer(tabController: widget.tabController!),
          ],
        ),
      ),
    );
  }
}
