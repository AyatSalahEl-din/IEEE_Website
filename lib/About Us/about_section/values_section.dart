import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/About Us/models/about_data_model.dart';
import 'package:ieee_website/About Us/widgets/value_card_widget.dart';

class ValuesSection extends StatelessWidget {
  final AboutDataModel? aboutData;

  const ValuesSection({Key? key, this.aboutData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fallback values if data is null
    final List<ValueItem> valuesData = aboutData?.values ?? [
      ValueItem(
        icon: 'people',
        title: 'Collaboration',
        description: 'Working together across IEEE disciplines to achieve common technological goals',
      ),
      ValueItem(
        icon: 'lightbulb',
        title: 'Innovation',
        description: 'Constantly seeking creative solutions to engineering challenges through IEEE resources',
      ),
      ValueItem(
        icon: 'trending_up',
        title: 'Excellence',
        description: 'Striving for the highest IEEE standards in all our technical endeavors',
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
      color: WebsiteColors.gradeintBlueColor.withOpacity(0.15),
      child: Column(
        children: [
          Text(
            aboutData?.valuesTitle ?? 'Our Values',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
          SizedBox(height: 60),
          // Values with icons
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 50,
            runSpacing: 40,
            children: valuesData.map((value) => ValueCardWidget(
              icon: value.icon,
              title: value.title,
              description: value.description,
            )).toList(),
          ),
        ],
      ),
    );
  }
}