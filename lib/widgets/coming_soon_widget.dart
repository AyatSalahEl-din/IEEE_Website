import 'package:flutter/material.dart';
import '../Themes/website_colors.dart';

class ComingSoonWidget extends StatelessWidget {
  final String message;

  const ComingSoonWidget({Key? key, this.message = "Coming Soon!"})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 100,
            color: WebsiteColors.primaryBlueColor,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.primaryBlueColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
