import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String watchVideoText;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.videoTitle,
    required this.watchVideoText,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      // Initialize video controller with provided URL
      _videoController = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        });
    } catch (e) {
      // Fallback to asset video if URL fails
      _videoController = VideoPlayerController.asset('assets/video/IEEE_Video.mp4')
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show improved video player when tapped
        _showFullScreenVideoDialog(context);
      },
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: WebsiteColors.darkBlueColor.withOpacity(0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // IEEE logo as background for video thumbnail
            Positioned(
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.school,
                  size: 120,
                  color: WebsiteColors.darkBlueColor,
                ),
              ),
            ),
            // Video title
            Positioned(
              top: 20,
              child: Text(
                widget.videoTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.darkBlueColor,
                ),
              ),
            ),
            // Play button with gradient effect
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    WebsiteColors.primaryBlueColor,
                    WebsiteColors.primaryBlueColor.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: WebsiteColors.primaryBlueColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
            // "Watch video" text
            Positioned(
              bottom: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: WebsiteColors.darkBlueColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.watchVideoText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            width: 700,
            height: 400,
            child: Stack(
              children: [
                // Video player with black background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: _isVideoInitialized
                      ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                      : Center(
                    child: CircularProgressIndicator(
                      color: WebsiteColors.primaryBlueColor,
                    ),
                  ),
                ),
                // Close button
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () {
                      _videoController.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // Play/Pause controls
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: VideoControlWidget(videoController: _videoController),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VideoControlWidget extends StatefulWidget {
  final VideoPlayerController videoController;

  const VideoControlWidget({Key? key, required this.videoController}) : super(key: key);

  @override
  _VideoControlWidgetState createState() => _VideoControlWidgetState();
}

class _VideoControlWidgetState extends State<VideoControlWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: Icon(
            widget.videoController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
          label: Text(
              widget.videoController.value.isPlaying
                  ? 'Pause'
                  : 'Play'
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: WebsiteColors.primaryBlueColor,
            foregroundColor: Colors.white,
            elevation: 5,
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12
            ),
          ),
          onPressed: () {
            setState(() {
              if (widget.videoController.value.isPlaying) {
                widget.videoController.pause();
              } else {
                widget.videoController.play();
              }
            });
          },
        ),
      ],
    );
  }
}