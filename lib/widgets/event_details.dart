import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Themes/website_colors.dart';
import 'event_model.dart';
import 'footer.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final TabController? tabController;

  const EventDetailsScreen({Key? key, required this.event, this.tabController})
    : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < widget.event.imageUrls.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        title: Text(
          widget.event.name,
          style: TextStyle(
            color: WebsiteColors.whiteColor,
            fontSize:MediaQuery.of(context).size.width < 600 ?14:24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: MediaQuery.of(context).size.width < 600 ?14:24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    70,
                vertical:
                    70,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: WebsiteColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                          20
                        ),
                        border: Border.all(
                          color: WebsiteColors.greyColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                 20
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: widget.event.imageUrls.length,
                                    onPageChanged:
                                        (index) => setState(
                                          () => _currentPage = index,
                                        ),
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        widget.event.imageUrls[index],
                                        fit: BoxFit.fill,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.error,
                                            size:
                                               MediaQuery.of(context).size.width < 600 ?30:50,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                left:
                                    10,
                                child: _buildArrowButton(
                                  Icons.arrow_back_ios,
                                  isLeft: true,
                                ),
                              ),
                              Positioned(
                                right:
                                   10,
                                child: _buildArrowButton(
                                  Icons.arrow_forward_ios,
                                  isLeft: false,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:
                               20,
                          ),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: widget.event.imageUrls.length,
                            effect: WormEffect(
                              dotHeight:
                                  10,
                              dotWidth:
                                  10,
                              activeDotColor: WebsiteColors.primaryBlueColor,
                            ),
                          ),
                          SizedBox(
                            height:
                                30,
                          ),
                          Center(
                            child: _buildInfoRow(
                              Icons.timelapse_outlined,
                              "Time: ${widget.event.time}",
                            ),
                          ),
                          SizedBox(
                            height:
                                8,
                          ),
                          Center(
                            child: _buildInfoRow(
                              Icons.location_on,
                              "Location: ${widget.event.location}",
                            ),
                          ),
                          SizedBox(
                            height:
                                8,
                          ),
                          Center(
                            child: _buildInfoRow(
                              Icons.date_range,
                              // ignore: unnecessary_null_comparison
                              "Date: ${widget.event.date != null ? DateFormat('dd-MM-yyyy').format(widget.event.date) : 'Not Available'}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height:
                        70,
                  ),
                  _buildSectionTitle('Description'),
                  _buildSectionText(
                    widget.event.details,
                  ),
                ],
              ),
            ),
          ),
          if (widget.tabController != null)
            Footer(tabController: widget.tabController!),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, {required bool isLeft}) {
    bool isDisabled =
        isLeft
            ? _currentPage == 0
            : _currentPage == widget.event.imageUrls.length - 1;
    return GestureDetector(
      onTap:
          isDisabled
              ? null
              : () {
                if (isLeft && _currentPage > 0) {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else if (!isLeft &&
                    _currentPage < widget.event.imageUrls.length - 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isDisabled
                  ? Colors.grey.withOpacity(0.5)
                  : Colors.black.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size:MediaQuery.of(context).size.width < 600 ?20:30,),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: WebsiteColors.darkBlueColor,
          fontSize: MediaQuery.of(context).size.width < 600 ?20:40,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        text.isNotEmpty ? text : "No details available",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: WebsiteColors.darkGreyColor,
          fontSize:MediaQuery.of(context).size.width < 600 ?16:30,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: WebsiteColors.primaryBlueColor,
          size: MediaQuery.of(context).size.width < 600 ?20:30,
        ),
        SizedBox(width: 8),
        Expanded(  // prevent overflow by letting text wrap
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: WebsiteColors.primaryBlueColor,
              fontSize: MediaQuery.of(context).size.width < 600 ?12:18,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}
}