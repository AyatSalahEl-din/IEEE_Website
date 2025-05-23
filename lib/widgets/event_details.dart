import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Themes/website_colors.dart';
import 'event_model.dart';
import 'footer.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final TabController? tabController;

  const EventDetailsScreen({Key? key, required this.event, this.tabController}) : super(key: key);

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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: WebsiteColors.primaryBlueColor,
        title: Text(
          widget.event.name,
          style: TextStyle(color: WebsiteColors.whiteColor, fontSize: 35.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 70.sp, vertical: 70.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: WebsiteColors.whiteColor,
                        borderRadius: BorderRadius.circular(20.sp),
                        border: Border.all(color: WebsiteColors.greyColor, width: 1),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.sp),
                                child: SizedBox(
                                  width: width * 0.7,
                                  height: width * 0.5,
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: widget.event.imageUrls.length,
                                    onPageChanged: (index) => setState(() => _currentPage = index),
                                    itemBuilder: (context, index) {
                                      // Network image for each URL in the list
                                      return Image.network(
                                        widget.event.imageUrls[index],
                                        fit: BoxFit.fill,
                                        errorBuilder: (context, error, stackTrace) {
                                          // Fallback to a placeholder in case of error
                                          return const Icon(Icons.error);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Navigation Arrows and Other UI components
                              Positioned(
                                left: 10.sp,
                                child: _buildArrowButton(Icons.arrow_back_ios, isLeft: true),
                              ),
                              Positioned(
                                right: 10.sp,
                                child: _buildArrowButton(Icons.arrow_forward_ios, isLeft: false),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.sp),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: widget.event.imageUrls.length,
                            effect: WormEffect(
                              dotHeight: 10.sp
                              ,
                              dotWidth: 10.sp,
                              activeDotColor: WebsiteColors.primaryBlueColor,
                            ),
                          ),
                          SizedBox(height: 30.sp),
                          Center(child: _buildInfoRow(Icons.timelapse_outlined, "Time: ${widget.event.time ?? 'Not Available'}")),
                          SizedBox(height: 8.sp),
                          Center(child: _buildInfoRow(Icons.location_on, "Location: ${widget.event.location ?? 'Not Available'}")),
                          SizedBox(height: 8.sp),
                          Center(
                            child: _buildInfoRow(
                              Icons.date_range,
                              "Date: ${widget.event.date!= null
                                  ? DateFormat('dd-MM-yyyy').format((widget.event.date))
                                  : 'Not Available'}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 70.sp),
                  _buildSectionTitle('Description'),
                  _buildSectionText(widget.event.details ?? "No details available"),
                ],
              ),
            ),
          ),
          if (widget.tabController != null) Footer(tabController: widget.tabController!),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, {required bool isLeft}) {
    bool isDisabled = isLeft ? _currentPage == 0 : _currentPage == widget.event.imageUrls.length - 1;
    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
        if (isLeft && _currentPage > 0) {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else if (!isLeft && _currentPage < widget.event.imageUrls.length - 1) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.withOpacity(0.5) : Colors.black.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 30.sp),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.sp),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: WebsiteColors.darkBlueColor,
          fontSize: 40.sp,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10.sp),
      child: Text(
        text.isNotEmpty ? text : "No details available",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: WebsiteColors.primaryBlueColor,
          fontSize: 30.sp,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: WebsiteColors.primaryBlueColor),
        SizedBox(width: 8.sp),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: WebsiteColors.primaryBlueColor,
            fontSize: 30.sp,
          ),
        ),
      ],
    );
  }
}
