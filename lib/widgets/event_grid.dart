import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/widgets/event_model.dart';
import '../Themes/website_colors.dart';
import 'Glow_button.dart';
import 'events_card.dart';

class EventsGrid extends StatefulWidget {
  final TabController? tabController;
  final String filterType;
  final String searchText;
  final String selectedFilter;

  const EventsGrid({
    Key? key,
    this.tabController,
    required this.filterType,
    required this.searchText,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  _EventsGridState createState() => _EventsGridState();
}

class _EventsGridState extends State<EventsGrid> {
  List<Event> allEvents = [];
  int itemsToShow = 6;

  @override
  void initState() {
    super.initState();
    fetchEventsFromFirestore();
  }

  Future<void> fetchEventsFromFirestore() async {
    try {
      Query query = FirebaseFirestore.instance.collection('events');

      if (widget.filterType == "upcoming") {
        query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()));
      } else if (widget.filterType == "previous") {
        query = query.where('date', isLessThan: Timestamp.fromDate(DateTime.now()));
      }

      QuerySnapshot snapshot = await query.orderBy('date', descending: true).get();
      List<Event> events = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Event.fromFirestore(data);
      }).toList();

      setState(() {
        allEvents = events;
      });
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void toggleItemsToShow() {
    setState(() {
      if (itemsToShow == 6) {
        itemsToShow = filteredEvents.length;
      } else {
        itemsToShow = 6;
      }
    });
  }

  List<Event> get filteredEvents {
    DateTime now = DateTime.now();
    return allEvents.where((event) {
      bool matchesFilter = true;

      if (widget.selectedFilter == "Today") {
        matchesFilter = event.date.year == now.year &&
            event.date.month == now.month &&
            event.date.day == now.day;
      } else if (widget.selectedFilter == "This Week") {
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        matchesFilter = event.date.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
            event.date.isBefore(endOfWeek.add(Duration(days: 1)));
      } else if (widget.selectedFilter == "This Month") {
        matchesFilter = event.date.year == now.year && event.date.month == now.month;
      }

      bool matchesSearch = event.name.toLowerCase().contains(widget.searchText.toLowerCase()) ||
          event.category.toLowerCase().contains(widget.searchText.toLowerCase()) ||
          event.location.toLowerCase().contains(widget.searchText.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Event> visibleEvents = filteredEvents.take(itemsToShow).toList();

    Map<int, List<Event>> groupedByYear = {};

    for (var event in visibleEvents) {
      groupedByYear.putIfAbsent(event.date.year, () => []).add(event);
    }

    return Column(
      children: [
         SizedBox(height: 10.sp),
        ...groupedByYear.entries.map((entry) {
          int year = entry.key;
          List<Event> events = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern Year Header
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 20.sp),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        endIndent: 10,
                        indent: 20,
                      ),
                    ),
                    Container(
                      padding:  EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.greenAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "$year",
                        style:Theme.of(context).textTheme.bodyMedium?.copyWith(color: WebsiteColors.whiteColor,fontSize: 30.sp)
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                        endIndent: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Events of this year
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: EventsCard(
                      event: events[index],
                      tabController: widget.tabController,
                    ),
                  );
                },
              ),
            ],
          );
        }).toList(),
        const SizedBox(height: 20),
        GlowButton(
          itemsToShow: itemsToShow,
          allEvents: filteredEvents,
          toggleItemsToShow: toggleItemsToShow,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
