import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Our%20Work/Events/bookingscreen.dart';
import 'package:ieee_website/widgets/event_grid.dart';
import 'package:ieee_website/widgets/footer.dart';
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  // Background Image
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
                  Container(
                    margin: EdgeInsets.only(
                      left: 400.sp,
                      right: 200.sp,
                      top: 400.sp,
                      bottom: 500.sp,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.sp),
                      color: WebsiteColors.whiteColor,
                    ),
                    width: width.spMax, // Adjust width to fit design
                    padding: EdgeInsets.all(15.sp),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Even spacing
                      children: [
                        Icon(
                          Icons.search,
                          color: WebsiteColors.darkGreyColor,
                          size: 25.sp,
                        ),
                        Text(
                          "   Search Events, Categories, Location...",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: WebsiteColors.lightGreyColor),
                        ),
                        Spacer(),
                        ImageIcon(
                          AssetImage("assets/images/location_icon.png"),
                        ),
                        Text(
                          "  Location ",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: WebsiteColors.darkGreyColor),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: WebsiteColors.darkGreyColor,
                        ),
                      ],
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
              // Upcoming Events Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcoming events
                    Text(
                      "Upcoming Events",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: WebsiteColors.primaryBlueColor,
                        fontSize: 40.sp,
                      ),
                    ),
                    SizedBox(height: 25.sp),
                    // Filter Chips
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
                    EventsGrid(
                      filterType: "upcoming",
                    ), // Fetch and display upcoming events
                    SizedBox(height: 45.sp),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            20.sp,
                          ), // Adjust circular border
                          child: Container(
                            height: 430.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20.sp,
                              ), // Ensures clipping
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/book_your_seat.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  20.sp,
                                ), // Apply border to overlay
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
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: WebsiteColors.darkBlueColor,
                                  fontSize: 38.sp,
                                ),
                              ),
                              SizedBox(height: 10.sp),
                              Text(
                                "Empowering Ideas, Connecting Minds",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: WebsiteColors.whiteColor,
                                  fontSize: 36.sp,
                                ),
                              ),
                              SizedBox(height: 5.sp),
                              Text(
                                "Seamless Booking for Every Event!",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: WebsiteColors.whiteColor,
                                  fontSize: 36.sp,
                                ),
                              ),
                              SizedBox(height: 20.sp),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the Booking Screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EventBookingPage(
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      WebsiteColors.primaryYellowColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.sp,
                                    vertical: 6.sp,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.sp,
                                    ), // Rounded button
                                  ),
                                ),
                                child: Text(
                                  "Book Your Seat",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
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
                    // Previous events
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
                    EventsGrid(
                      filterType: "previous",
                    ), // Fetch and display previous events
                    SizedBox(height: 20.sp),
                    // Join Us Section
                    // Footer
                  ],
                ),
              ),
            ],
          ),
          if (widget.tabController != null)
            Footer(tabController: widget.tabController!),
        ],
      ),
    );
  }
}
