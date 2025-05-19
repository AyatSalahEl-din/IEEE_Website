import 'package:flutter/material.dart';
import '../FAQ/faq_item_model.dart';
import '../Themes/website_colors.dart';
class FAQItemWidget extends StatelessWidget {
  final FAQItemModel item;
  final Function(bool) onExpansionChanged;

  FAQItemWidget({
    required this.item,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: item.isExpanded ? WebsiteColors.gradeintBlueColor : WebsiteColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isExpanded ? WebsiteColors.primaryBlueColor : WebsiteColors.greyColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: item.isExpanded,
        onExpansionChanged: onExpansionChanged,
        title: Text(
          item.question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: item.isExpanded ? WebsiteColors.primaryBlueColor : WebsiteColors.darkGreyColor,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          item.isExpanded ? Icons.arrow_circle_up_outlined : Icons.arrow_circle_right_outlined,
          color: item.isExpanded ? WebsiteColors.primaryBlueColor : WebsiteColors.darkGreyColor,
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.answer,
                style: TextStyle(
                  color: WebsiteColors.descGreyColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}