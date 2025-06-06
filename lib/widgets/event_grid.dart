import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ieee_website/widgets/event_model.dart';
import 'Glow_button.dart';
import 'events_card.dart';

class EventsGrid extends StatefulWidget {
  final TabController? tabController;
  final String filterType;
  final String searchText;
  final String selectedFilter;
  final Widget Function() onEmpty;

  const EventsGrid({
    Key? key,
    this.tabController,
    required this.filterType,
    required this.searchText,
    required this.selectedFilter,
    required this.onEmpty,
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

      QuerySnapshot snapshot = await query.orderBy('date', descending: true).get();
      List<Event> events = snapshot.docs.map((doc) {
        return Event.fromFirestore(doc);
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
          matchesFilter = event.date.year == now.year &&
              event.date.month == now.month &&
              event.date.day == now.day;
        } else if (widget.selectedFilter == "This Week") {
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
          matchesFilter = event.date.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
              event.date.isBefore(endOfWeek.add(Duration(seconds: 1)));
        } else if (widget.selectedFilter == "This Month") {
          matchesFilter = event.date.year == now.year && event.date.month == now.month;
        }
      } else if (widget.filterType == "previous") {
        if (widget.selectedFilter == "Last Week") {
          DateTime startOfLastWeek = now.subtract(Duration(days: now.weekday + 6));
          DateTime endOfLastWeek = startOfLastWeek.add(Duration(days: 6));
          matchesFilter = event.date.isAfter(startOfLastWeek.subtract(Duration(seconds: 1))) &&
              event.date.isBefore(endOfLastWeek.add(Duration(seconds: 1)));
        } else if (widget.selectedFilter == "Last Month") {
          DateTime startOfLastMonth = DateTime(now.year, now.month - 1, 1);
          DateTime endOfLastMonth = DateTime(now.year, now.month, 0);
          matchesFilter = event.date.isAfter(startOfLastMonth.subtract(Duration(seconds: 1))) &&
              event.date.isBefore(endOfLastMonth.add(Duration(seconds: 1)));
        } else if (widget.selectedFilter == "Last Year") {
          matchesFilter = event.date.year == now.year - 1;
        } else if (widget.selectedFilter == "This Year") {
          matchesFilter = event.date.year == now.year;
        }
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

    if (filteredEvents.isEmpty) {
      return widget.onEmpty();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400.0,
                childAspectRatio: 16 / 12,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: visibleEvents.length,
              itemBuilder: (context, index) {
                return EventsCard(
                  event: visibleEvents[index],
                  tabController: widget.tabController,
                );
              },
            ),
            const SizedBox(height: 32),
            if (filteredEvents.length > 6)
              GlowButton(
                itemsToShow: itemsToShow,
                allEvents: filteredEvents,
                toggleItemsToShow: toggleItemsToShow,
              ),
          ],
        );
      },
    );
  }
}
