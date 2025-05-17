import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Our%20Work/Events/bookingscreen.dart';
import 'package:ieee_website/widgets/event_grid.dart';
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
  String searchText = '';
  String selectedFilter = 'All';
  bool isChatOpen = false;

  void _launchURL() async {
    final Uri url = Uri.parse("https://www.linkedin.com/in/menna-allah-rabei-a3565131a/");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  void _toggleChat() {
    setState(() {
      isChatOpen = !isChatOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double bgHeight = screenHeight * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: WebsiteColors.primaryBlueColor,
        onPressed: _toggleChat,
        child: Icon(Icons.chat_bubble_outline),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              children: [
                // Background with search bar and sentence
                Stack(
                  children: [
                    Container(
                      height: bgHeight,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/Mask group.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                    Positioned(
                      top: bgHeight * 0.4,
                      left: width * 0.1,
                      right: width * 0.1,
                      child: Container(
                        height: 80.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30.sp),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: WebsiteColors.darkGreyColor, size: 30.sp),
                            SizedBox(width: 15.sp),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Search Events, Categories, Location...",
                                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: WebsiteColors.lightGreyColor,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: 15.sp),
                            ImageIcon(AssetImage("assets/images/location_icon.png")),
                            SizedBox(width: 10.sp),
                            Text(
                              "Location",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: WebsiteColors.darkGreyColor,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: WebsiteColors.darkGreyColor),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: bgHeight * 0.5 + 90.sp,
                      left: width * 0.1,
                      right: width * 0.1,
                      child: Text(
                        "Don't miss out! Explore our events.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 3, color: Colors.black45)],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                // Upcoming Events Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 40.sp),
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
                        children: [
                          for (var filter in ["All", "Today", "This Week", "This Month"])
                            FilterChipWidget(
                              label: filter,
                              isSelected: selectedFilter == filter,
                              onSelected: () {
                                setState(() {
                                  selectedFilter = filter;
                                });
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 30.sp),
                      EventsGrid(
                        filterType: "upcoming",
                        searchText: searchText,
                        selectedFilter: selectedFilter,
                      ),

                      SizedBox(height: 45.sp),

                      // Book Banner
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.sp),
                            child: Container(
                              height: 430.sp,
                              decoration: BoxDecoration(
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
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const EventBookingPage(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: WebsiteColors.primaryYellowColor,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.sp,
                                          vertical: 6.sp,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.sp),
                                        ),
                                      ),
                                      child: Text(
                                        "Book Your Ticket",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: WebsiteColors.darkBlueColor,
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20.sp),
                                    ElevatedButton(
                                      onPressed: _launchURL,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: WebsiteColors.primaryYellowColor,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.sp,
                                          vertical: 6.sp,
                                        ),
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
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 40.sp),

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
                        children: [
                          for (var filter in ["All", "Today", "This Week", "This Month"])
                            FilterChipWidget(
                              label: filter,
                              isSelected: selectedFilter == filter,
                              onSelected: () {
                                setState(() {
                                  selectedFilter = filter;
                                });
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 30.sp),
                      EventsGrid(
                        filterType: "previous",
                        searchText: searchText,
                        selectedFilter: selectedFilter,
                      ),
                      SizedBox(height: 20.sp),

                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isChatOpen)
            Positioned(
              bottom: 90,
              right: 20,
              child: Container(
                height: 800.sp,
                width: 600.sp,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: WebsiteColors.primaryBlueColor),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: ChatbotHomeScreen(),
              ),
            ),
        ],
      ),
    );
  }
}
