import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Our%20Work/Events/bookingscreen.dart';
import 'package:ieee_website/widgets/event_grid.dart';
import 'package:ieee_website/widgets/footer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Themes/website_colors.dart';
import '../../chatbot/chatbot_home_screen.dart';
import '../../widgets/filter_chip_widget.dart';

class Events extends StatefulWidget {
  static const String routeName = 'events';
  final TabController? tabController;

  const Events({super.key, this.tabController});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {

  
  bool isHovered = false;

  String searchText = '';
  String selectedFilter = 'All';
  bool isChatOpen = false;

  void _launchURL() async {
    final Uri url = Uri.parse(
      "https://www.linkedin.com/in/menna-allah-rabei-a3565131a/",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  // Function to toggle chat visibility
  void _toggleChat() {
    setState(() {
      isChatOpen = !isChatOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              children: [
                Column(
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

                    Expanded(
                      child: Container(
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
                              size: 30.sp,
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      "Search Events, Categories, Location...",
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: WebsiteColors.lightGreyColor,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            ImageIcon(
                              AssetImage("assets/images/location_icon.png"),
                            ),
                            Text(
                              "  Location ",
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: WebsiteColors.darkGreyColor,
                              ),

                   
                            ),
                            width: width.spMax,
                            padding: EdgeInsets.all(15.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: WebsiteColors.darkGreyColor,
                                  size: 30.sp,
                                ),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchText = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                      "Search Events, Categories, Location...",
                                      hintStyle: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: WebsiteColors.lightGreyColor,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                ImageIcon(
                                  AssetImage("assets/images/location_icon.png"),
                                ),
                                Text(
                                  "  Location ",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: WebsiteColors.darkGreyColor,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: WebsiteColors.darkGreyColor,
                                ),
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
                      ),

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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const EventBookingPage(),
                                      ),
                                    ); // Navigate to booking screen
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        WebsiteColors.primaryYellowColor,
                                    textStyle: const TextStyle(
                                      color: WebsiteColors.darkBlueColor,
                                    ),
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
                                    "Book Your Ticket", // Button text
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: WebsiteColors.darkBlueColor,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,

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
                                      onPressed: _launchURL,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        WebsiteColors.primaryYellowColor,
                                        textStyle: const TextStyle(
                                          color: WebsiteColors.darkBlueColor,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.sp,
                                          vertical: 6.sp,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.sp,
                                          ),
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

                          // Previous Events Section
                          Text(
                            "Previous Events",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: WebsiteColors.primaryBlueColor,
                              fontSize: 40.sp,
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
                      ),

                      SizedBox(height: 20.sp),
                    ],
                  ),

                ),
              ),
            ),
        ],
      ),
    );
  }
}
