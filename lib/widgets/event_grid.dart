import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_model.dart';
import 'Glow_button.dart';
import 'events_card.dart';

class EventsGrid extends StatefulWidget {
  final TabController? tabController;
  final String filterType;

  const EventsGrid({Key? key, this.tabController, required this.filterType})
    : super(key: key);

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
        query = query
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()),
            )
            .orderBy('date', descending: false); // Fetch upcoming events
      } else if (widget.filterType == "previous") {
        query = query
            .where('date', isLessThan: Timestamp.fromDate(DateTime.now()))
            .orderBy('date', descending: true); // Fetch previous events
      }

      QuerySnapshot snapshot = await query.get();
      List<Event> events =
          snapshot.docs
              .map((doc) {
                try {
                  return Event.fromFirestore(
                    doc,
                  ); // Use Event model to parse data
                } catch (e) {
                  print("Error parsing event document: ${doc.id}, error: $e");
                  return null;
                }
              })
              .whereType<Event>()
              .toList(); // Filter out null values

      setState(() {
        allEvents = events;
      });
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void toggleItemsToShow() {
    setState(() {
      // If showing less (6), change it to show all events
      if (itemsToShow == 6) {
        itemsToShow = allEvents.length;
      } else {
        itemsToShow = 6; // Otherwise, show just 6 events
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Event> visibleEvents = allEvents.take(itemsToShow).toList();

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          widget.filterType.toUpperCase(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: double.infinity),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: visibleEvents.length,
            itemBuilder: (context, index) {
              return EventsCard(
                event: visibleEvents[index],
                tabController: widget.tabController,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        GlowButton(
          itemsToShow: itemsToShow,
          allEvents: allEvents,
          toggleItemsToShow: toggleItemsToShow, // Pass the toggle function
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
