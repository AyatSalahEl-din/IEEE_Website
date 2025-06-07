import 'package:flutter/material.dart';
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
  String searchText = '';
  String upcomingSelectedFilter = 'All';
  String previousSelectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
               Container(
          height:80,
          width: double.infinity,
          decoration: const BoxDecoration(
            color:WebsiteColors.primaryBlueColor,
            
          ),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
                _buildHeroSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upcoming Events Section
                      _buildSectionHeader("Upcoming Events"),
                      _buildUpcomingFilter(),
                      const SizedBox(height: 24),
                      EventsGrid(
                        filterType: "upcoming",
                        searchText: searchText,
                        selectedFilter: upcomingSelectedFilter,
                        onEmpty: () => const ComingSoonWidget(),
                      ),
                      const SizedBox(height: 40),
                      _buildBookingBanner(),
                      const SizedBox(height: 40),

                      // Previous Events Section
                      _buildSectionHeader(
                        "Previous Events",
                        color: WebsiteColors.primaryBlueColor,
                      ),
                      _buildPreviousFilter(),
                      const SizedBox(height: 24),
                      EventsGrid(
                        filterType: "previous",
                        searchText: searchText,
                        selectedFilter: previousSelectedFilter,
                        onEmpty: () => const ComingSoonWidget(),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.tabController != null)
            SliverToBoxAdapter(
              child: Footer(tabController: widget.tabController!),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    Color color = WebsiteColors.primaryBlueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://raw.githubusercontent.com/AyatSalahEl-din/IEEE_Images/refs/heads/main/mm.png'),

              fit: BoxFit.cover,)
            
          ),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Don't miss out! Explore our events.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.black54)],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
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
        return Container(
          width: 500,
          height: 40,
          decoration: BoxDecoration(
            color: WebsiteColors.whiteColor,
            borderRadius: BorderRadius.circular(25),
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
                fontSize: 16,
                color: WebsiteColors.primaryBlueColor,
              ),
              decoration: InputDecoration(
                hintText: "Search Events, Categories, Location...",
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  color: WebsiteColors.primaryBlueColor.withOpacity(0.7),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: WebsiteColors.primaryBlueColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: WebsiteColors.primaryBlueColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: WebsiteColors.primaryBlueColor,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                isCollapsed: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: AspectRatio(
              aspectRatio:
                  isSmallScreen ? 3 / 2 : 16 / 5, // Adjusted aspect ratio
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://raw.githubusercontent.com/AyatSalahEl-din/IEEE_Images/refs/heads/main/book.png",
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withOpacity(0.3)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Secure your Spot",
                          style: TextStyle(
                            color: WebsiteColors.primaryYellowColor,
                            fontSize: isSmallScreen ? 26 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Empowering Ideas, Connecting Minds.",
                          style: TextStyle(
                            color: WebsiteColors.whiteColor,
                            fontSize: isSmallScreen ? 18 : 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => const EventBookingPage(),
                                ),
                              ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  WebsiteColors.primaryYellowColor,
                                  const Color.fromARGB(255, 255, 255, 255),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Text(
                              "Book Your Ticket",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: WebsiteColors.lightGreyColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingFilter() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        FilterChipWidget(
          label: "All",
          isSelected: upcomingSelectedFilter == "All",
          onSelected: () => setState(() => upcomingSelectedFilter = "All"),
        ),
        FilterChipWidget(
          label: "Today",
          isSelected: upcomingSelectedFilter == "Today",
          onSelected: () => setState(() => upcomingSelectedFilter = "Today"),
        ),
        FilterChipWidget(
          label: "This Week",
          isSelected: upcomingSelectedFilter == "This Week",
          onSelected:
              () => setState(() => upcomingSelectedFilter = "This Week"),
        ),
        FilterChipWidget(
          label: "This Month",
          isSelected: upcomingSelectedFilter == "This Month",
          onSelected:
              () => setState(() => upcomingSelectedFilter = "This Month"),
        ),
      ],
    );
  }

  Widget _buildPreviousFilter() {
    // ✨ Replaced Row with Wrap for responsiveness
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        FilterChipWidget(
          label: "All",
          isSelected: previousSelectedFilter == "All",
          onSelected: () => setState(() => previousSelectedFilter = "All"),
        ),
        FilterChipWidget(
          label: "Last Month",
          isSelected: previousSelectedFilter == "Last Month",
          onSelected:
              () => setState(() => previousSelectedFilter = "Last Month"),
        ),
        FilterChipWidget(
          label: "This Year",
          isSelected: previousSelectedFilter == "This Year",
          onSelected:
              () => setState(() => previousSelectedFilter = "This Year"),
        ),
        FilterChipWidget(
          label: "Last Year",
          isSelected: previousSelectedFilter == "Last Year",
          onSelected:
              () => setState(() => previousSelectedFilter = "Last Year"),
        ),
      ],
    );
  }
}
