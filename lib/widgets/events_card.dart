import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'event_model.dart';
import 'event_details.dart';

class EventsCard extends StatefulWidget {
  final Event event;
  final TabController? tabController;

  static const Map<String, List<String>> eventImageMap = {
    // Define fallback local images here
  };

  const EventsCard({Key? key, required this.event, this.tabController})
      : super(key: key);

  @override
  State<EventsCard> createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isClicked = true),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() => isClicked = false);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsScreen(
                event: widget.event,
                tabController: widget.tabController,
              ),
            ),
          );
        });
      },
      onTapCancel: () => setState(() => isClicked = false),
      child: LayoutBuilder(
  builder: (context, constraints) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transform: isClicked
          ? (Matrix4.identity()..scale(1.03))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 179, 179, 179),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // Avoid accidental scrolls
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _buildEventCardImage(),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.event.isOnlineEvent
                                ? Colors.green.shade100
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                widget.event.isOnlineEvent
                                    ? Icons.wifi
                                    : Icons.location_on,
                                size: 16,
                                color: widget.event.isOnlineEvent
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.event.isOnlineEvent ? 'Online' : 'Offline',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.event.isOnlineEvent
                                      ? Colors.green
                                      : Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical:12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                           Text(
                            widget.event.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: WebsiteColors.darkBlueColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
)
    );
  }

  Widget _buildEventCardImage() {
    List<String>? firebaseImages = widget.event.imageUrls;
    List<String>? localImages = EventsCard.eventImageMap[widget.event.name];
    String? firstImage;

    if (firebaseImages != null && firebaseImages.isNotEmpty) {
      firstImage = firebaseImages.first;
    } else if (localImages != null && localImages.isNotEmpty) {
      firstImage = localImages.first;
    }

    return firstImage != null
        ? firstImage.startsWith("http")
            ? Image.network(
                firstImage,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              )
            : Image.asset(firstImage, width: double.infinity, fit: BoxFit.cover)
        : Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
  }
}

