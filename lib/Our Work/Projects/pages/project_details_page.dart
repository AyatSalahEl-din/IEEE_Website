import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:intl/intl.dart';
import '../models/project_model.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: WebsiteColors.primaryBlueColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 120.sp, vertical: 60.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: 20.sp),
            Text(
              project.title,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.sp),
            Row(
              children: [
                Text(
                  "Made By: ${project.madeBy}",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(width: 40.sp),
                Text(
                  DateFormat('dd MMMM yyyy').format(project.date),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.sp),
            Wrap(
              spacing: 10.sp,
              runSpacing: 10.sp,
              children: project.tags.map((tag) => _buildTag(context, tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 120.sp, vertical: 60.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project Description",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: WebsiteColors.primaryBlueColor,fontSize: 40.sp
            ),
          ),
          SizedBox(height: 20.sp),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 24.sp,color: WebsiteColors.darkBlueColor,
              height: 1.8,
            ),
          ),
          if (project.additionalDetails != null) ...[
            SizedBox(height: 40.sp),
            Text(
              "Additional Details",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: WebsiteColors.primaryBlueColor,fontSize: 40.sp
              ),
            ),
            SizedBox(height: 20.sp),
            ...project.additionalDetails!.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: 10.sp),
                child: Row(
                  children: [
                    Text(
                      "${entry.key.replaceAll('_', ' ').toUpperCase()}: ",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: WebsiteColors.primaryBlueColor,
                      ),
                    ),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 40.sp),
          Container(
            width: double.infinity,
            height: 400.sp,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.sp),
            ),
            child: Center(
              child: Text(
                "Project Images Coming Soon",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.white,fontSize: 18.sp
        ),
      ),
    );
  }
}
