import 'package:flutter/material.dart';
import 'dart:async'; // Import this for Timer

class ContinuousSlideshow extends StatefulWidget {
  @override
  _ContinuousSlideshowState createState() => _ContinuousSlideshowState();
}

class _ContinuousSlideshowState extends State<ContinuousSlideshow> {
  int currentIndex = 0;
  bool isHovered = false;
  late Timer _timer;

  final List<Map<String, String>> sliderItems = [
    {
      'image': 'assets/images/Picture1.png',
      'description':
          'Description for Slide 1dsgfsdfsfijsoifuhwsifeuhsidfjhskdfjhsdifjkhsdkfjdfhiosuhrfowiuh wuehrfowiuefh oufh wsiuf hweioufh oiu hwoei ho iuhwsofiuhr fiu sdf sdfsd sd sdg dfg dfgdfg sdfgdfgdfg dfgd dfg',
    },
    {
      'image': 'assets/images/Picture2.png',
      'description': 'Description for Slide 2',
    },
    {
      'image': 'assets/images/Picture3.png',
      'description': 'Description for Slide 3',
    },
    {
      'image': 'assets/images/Picture4.png',
      'description': 'Description for Slide 4',
    },
    {
      'image': 'assets/images/Picture5.png',
      'description': 'Description for Slide 5',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startSlideshow();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!isHovered) {
        // Pause slideshow when hovered
        setState(() {
          currentIndex = (currentIndex + 1) % sliderItems.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Slideshow
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: ClipRRect(
                key: ValueKey<int>(currentIndex),
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  sliderItems[currentIndex]['image']!,
                  fit: BoxFit.cover,
                  width: 400,
                  height: 250,
                ),
              ),
            ),
            SizedBox(width: 20),

            // Description Box
            MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 250,
                height: 100,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    sliderItems[currentIndex]['description']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
