import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Our%20Work/Events/bookingscreen.dart';
import 'package:ieee_website/widgets/coming_soon_widget.dart';
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
  String searchText = ''; // State for search text
  String selectedFilter = 'All'; // State for selected filter
  bool isHovered = false;

  void _launchURL() async {
    final Uri url = Uri.parse(
      "https://www.linkedin.com/in/menna-allah-rabei-a3565131a/",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

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
                    height: 500.sp,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Mask group.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                  Positioned(
                    top: 200.sp,
                    left: 100.sp,
                    right: 100.sp,
                    child: Column(
                      children: [
                        Text(
                          "Don't miss out! Explore our events.",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: WebsiteColors.whiteColor),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.sp),
                        _buildSearchBar(),
                      ],
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
                        FilterChipWidget(
                          label: "All",
                          isSelected: selectedFilter == "All",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "All";
                            });
                          },
                        ),
                        FilterChipWidget(
                          label: "Today",
                          isSelected: selectedFilter == "Today",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "Today";
                            });
                          },
                        ),
                        FilterChipWidget(
                          label: "This Week",
                          isSelected: selectedFilter == "This Week",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "This Week";
                            });
                          },
                        ),
                        FilterChipWidget(
                          label: "This Month",
                          isSelected: selectedFilter == "This Month",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "This Month";
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 30.sp),

                    // Pass searchText and selectedFilter to EventsGrid
                    EventsGrid(
                      filterType: "upcoming",
                      searchText: searchText,
                      selectedFilter: selectedFilter,
                      onEmpty: () => ComingSoonWidget(),
                    ),

                    SizedBox(height: 45.sp),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.sp),
                          child: Container(
                            height: 430.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.sp),
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
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0, // Align to the bottom
                          left: 0, // Align to the left
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => const EventBookingPage(),
                                ),
                              ); // Navigate to booking screen
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Remove padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.sp),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(20.sp),
                                ),
                              ),
                              elevation: 5,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    WebsiteColors.primaryYellowColor,
                                    const Color.fromARGB(255, 255, 230, 190),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.sp),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(20.sp),
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 30.sp,
                                  horizontal: 40.sp,
                                ),
                                child: Text(
                                  "Book Your Ticket", // Button text
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: WebsiteColors.darkBlueColor,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.sp),

                    // Previous Events Section
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
                        FilterChipWidget(
                          label: "All",
                          isSelected: selectedFilter == "All",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "All";
                            });
                          },
                        ),
                        FilterChipWidget(
                          label: "Today",
                          isSelected: selectedFilter == "Today",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "Today";
                            });
                          },
                        ),
                        FilterChipWidget(
                          label: "This Week",
                          isSelected: selectedFilter == "This Week",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "This Week";
                            });
                          },
                        ),
                        FilterChipWidget(
                          label: "This Month",
                          isSelected: selectedFilter == "This Month",
                          onSelected: () {
                            setState(() {
                              selectedFilter = "This Month";
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 30.sp),

                    // Pass searchText and selectedFilter to EventsGrid
                    EventsGrid(
                      filterType: "previous",
                      searchText: searchText,
                      selectedFilter: selectedFilter,
                      onEmpty: () => ComingSoonWidget(),
                    ),

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
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 600.sp,
      decoration: BoxDecoration(
        color: WebsiteColors.whiteColor,
        borderRadius: BorderRadius.circular(30.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 20.sp,
        ),
        decoration: InputDecoration(
          hintText: "Search Events, Categories, Location...",
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontSize: 20.sp,
          ),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 25.sp,
            vertical: 15.sp,
          ),
          suffixIcon:
              searchText.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchText = '';
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
