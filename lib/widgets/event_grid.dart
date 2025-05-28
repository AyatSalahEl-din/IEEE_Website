import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/widgets/coming_soon_widget.dart';
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
    required ComingSoonWidget Function() onEmpty,
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
        query = query.where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()),
        );
      } else if (widget.filterType == "previous") {
        query = query.where(
          'date',
          isLessThan: Timestamp.fromDate(DateTime.now()),
        );
      }

      QuerySnapshot snapshot =
          await query.orderBy('date', descending: true).get();
      List<Event> events =
          snapshot.docs.map((doc) {
            return Event.fromFirestore(
              doc,
            ); // Pass the DocumentSnapshot directly
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

      if (widget.filterType == "upcoming") {
        if (widget.selectedFilter == "Today") {
          matchesFilter =
              event.date.year == now.year &&
              event.date.month == now.month &&
              event.date.day == now.day;
        } else if (widget.selectedFilter == "This Week") {
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
          matchesFilter =
              event.date.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
              event.date.isBefore(endOfWeek.add(Duration(seconds: 1)));
        } else if (widget.selectedFilter == "This Month") {
          matchesFilter =
              event.date.year == now.year && event.date.month == now.month;
        }
      } else if (widget.filterType == "previous") {
        if (widget.selectedFilter == "Last Week") {
          DateTime startOfLastWeek = now.subtract(
            Duration(days: now.weekday + 6),
          );
          DateTime endOfLastWeek = startOfLastWeek.add(Duration(days: 6));
          matchesFilter =
              event.date.isAfter(
                startOfLastWeek.subtract(Duration(seconds: 1)),
              ) &&
              event.date.isBefore(endOfLastWeek.add(Duration(seconds: 1)));
        } else if (widget.selectedFilter == "Last Month") {
          DateTime startOfLastMonth = DateTime(now.year, now.month - 1, 1);
          DateTime endOfLastMonth = DateTime(now.year, now.month, 0);
          matchesFilter =
              event.date.isAfter(
                startOfLastMonth.subtract(Duration(seconds: 1)),
              ) &&
              event.date.isBefore(endOfLastMonth.add(Duration(seconds: 1)));
        } else if (widget.selectedFilter == "Last Year") {
          matchesFilter = event.date.year == now.year - 1;
        } else if (widget.selectedFilter == "This Year") {
          matchesFilter = event.date.year == now.year;
        }
      }

      bool matchesSearch =
          event.name.toLowerCase().contains(widget.searchText.toLowerCase()) ||
          event.category.toLowerCase().contains(
            widget.searchText.toLowerCase(),
          ) ||
          event.location.toLowerCase().contains(
            widget.searchText.toLowerCase(),
          );

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
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 10.sp : 5.sp,
        ),
        ...groupedByYear.entries.map((entry) {
          int year = entry.key;
          List<Event> events = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical:
                      MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness:
                            MediaQuery.of(context).size.width > 600
                                ? 2.sp
                                : 1.sp,
                        endIndent:
                            MediaQuery.of(context).size.width > 600
                                ? 10.sp
                                : 5.sp,
                        indent:
                            MediaQuery.of(context).size.width > 600
                                ? 20.sp
                                : 10.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width > 600
                                ? 16.sp
                                : 8.sp,
                        vertical:
                            MediaQuery.of(context).size.width > 600
                                ? 8.sp
                                : 4.sp,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 35, 65, 117),
                            const Color.fromARGB(255, 145, 186, 227),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width > 600
                              ? 30.sp
                              : 15.sp,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius:
                                MediaQuery.of(context).size.width > 600
                                    ? 8.sp
                                    : 4.sp,
                            spreadRadius:
                                MediaQuery.of(context).size.width > 600
                                    ? 2.sp
                                    : 1.sp,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "$year",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: WebsiteColors.whiteColor,
                          fontSize:
                              MediaQuery.of(context).size.width > 600
                                  ? 30.sp
                                  : 20.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness:
                            MediaQuery.of(context).size.width > 600
                                ? 2.sp
                                : 1.sp,
                        indent:
                            MediaQuery.of(context).size.width > 600
                                ? 10.sp
                                : 5.sp,
                        endIndent:
                            MediaQuery.of(context).size.width > 600
                                ? 20.sp
                                : 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  childAspectRatio:
                      MediaQuery.of(context).size.width > 600 ? 3 / 2 : 4 / 3,
                  mainAxisSpacing:
                      MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
                  crossAxisSpacing:
                      MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
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
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
        ),
        GlowButton(
          itemsToShow: itemsToShow,
          allEvents: filteredEvents,
          toggleItemsToShow: toggleItemsToShow,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 10.sp : 5.sp,
        ),
      ],
    );
  }
}
