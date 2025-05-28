import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Our%20Work/Events/bookingscreen.dart';
import 'package:ieee_website/widgets/coming_soon_widget.dart';
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
  String searchText = ''; // State for search text
  String upcomingSelectedFilter = 'All'; // Separate state for upcoming filter
  String previousSelectedFilter = 'All'; // Separate state for previous filter
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              _buildHeroSection(),
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
                        fontSize:
                            MediaQuery.of(context).size.width > 600
                                ? 40.sp
                                : 24.sp,
                      ),
                    ),
                    SizedBox(height: 25.sp),

                    // Upcoming Events Filter Chips
                    _buildUpcomingFilter(),

                    SizedBox(height: 30.sp),

                    // Pass searchText and upcomingSelectedFilter to EventsGrid
                    EventsGrid(
                      filterType: "upcoming",
                      searchText: searchText,
                      selectedFilter: upcomingSelectedFilter,
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
                          bottom:
                              MediaQuery.of(context).size.width > 600
                                  ? 20.sp
                                  : 10.sp,
                          right:
                              MediaQuery.of(context).size.width > 600
                                  ? 20.sp
                                  : 10.sp,
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
                                borderRadius: BorderRadius.circular(20.sp),
                              ),
                              elevation: 5,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.black.withOpacity(0),
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
                                borderRadius: BorderRadius.circular(20.sp),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.width > 600
                                          ? 20.sp
                                          : 15.sp,
                                  horizontal:
                                      MediaQuery.of(context).size.width > 600
                                          ? 30.sp
                                          : 20.sp,
                                ),
                                child: Text(
                                  "Book Your Ticket", // Button text
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: WebsiteColors.darkBlueColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24.sp
                                            : 18.sp,
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

                    // Previous Events Filter Chips
                    _buildPreviousFilter(),

                    SizedBox(height: 30.sp),

                    // Pass searchText and previousSelectedFilter to EventsGrid
                    EventsGrid(
                      filterType: "previous",
                      searchText: searchText,
                      selectedFilter: previousSelectedFilter,
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

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width > 600 ? 500.sp : 300.sp,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Mask group.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(color: Colors.black.withOpacity(0.2)),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width > 600 ? 200.sp : 100.sp,
          left: MediaQuery.of(context).size.width > 600 ? 100.sp : 50.sp,
          right: MediaQuery.of(context).size.width > 600 ? 100.sp : 50.sp,
          child: Column(
            children: [
              Text(
                "Don't miss out! Explore our events.",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: WebsiteColors.whiteColor,
                  fontSize:
                      MediaQuery.of(context).size.width > 600 ? 28.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
              ),
              _buildSearchBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double searchBarWidth =
            constraints.maxWidth > 800.sp ? 600.sp : constraints.maxWidth * 0.8;

        return Container(
          width: searchBarWidth,
          height: 50.sp,
          decoration: BoxDecoration(
            color: WebsiteColors.whiteColor,
            borderRadius: BorderRadius.circular(25.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16.sp,
                color: WebsiteColors.primaryBlueColor,
              ),
              decoration: InputDecoration(
                hintText: "Search Events, Categories, Location...",
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16.sp,
                  color: WebsiteColors.primaryBlueColor.withOpacity(0.7),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.sp,
                  color: WebsiteColors.primaryBlueColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.sp),
                  borderSide: BorderSide(color: WebsiteColors.primaryBlueColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.sp),
                  borderSide: BorderSide(
                    color: WebsiteColors.primaryBlueColor,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.sp,
                  horizontal: 10.sp,
                ),
                isCollapsed: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FilterChipWidget(
          label: "All",
          isSelected: upcomingSelectedFilter == "All",
          onSelected: () {
            setState(() {
              upcomingSelectedFilter = "All";
            });
          },
        ),
        FilterChipWidget(
          label: "Today",
          isSelected: upcomingSelectedFilter == "Today",
          onSelected: () {
            setState(() {
              upcomingSelectedFilter = "Today";
            });
          },
        ),
        FilterChipWidget(
          label: "This Week",
          isSelected: upcomingSelectedFilter == "This Week",
          onSelected: () {
            setState(() {
              upcomingSelectedFilter = "This Week";
            });
          },
        ),
        FilterChipWidget(
          label: "This Month",
          isSelected: upcomingSelectedFilter == "This Month",
          onSelected: () {
            setState(() {
              upcomingSelectedFilter = "This Month";
            });
          },
        ),
      ],
    );
  }

  Widget _buildPreviousFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FilterChipWidget(
          label: "All",
          isSelected: previousSelectedFilter == "All",
          onSelected: () {
            setState(() {
              previousSelectedFilter = "All";
            });
          },
        ),
        FilterChipWidget(
          label: "Last Month",
          isSelected: previousSelectedFilter == "Last Month",
          onSelected: () {
            setState(() {
              previousSelectedFilter = "Last Month";
            });
          },
        ),
        FilterChipWidget(
          label: "This Year",
          isSelected: previousSelectedFilter == "This Year",
          onSelected: () {
            setState(() {
              previousSelectedFilter = "This Year";
            });
          },
        ),
        FilterChipWidget(
          label: "Last Year",
          isSelected: previousSelectedFilter == "Last Year",
          onSelected: () {
            setState(() {
              previousSelectedFilter = "Last Year";
            });
          },
        ),
      ],
    );
  }
}
