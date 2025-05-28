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
          children: [_buildHeader(context), _buildContent(context)],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: WebsiteColors.primaryBlueColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 120.sp : 60.sp,
          vertical: MediaQuery.of(context).size.width > 600 ? 60.sp : 30.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
            ),
            Text(
              project.title,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize:
                    MediaQuery.of(context).size.width > 600 ? 36.sp : 24.sp,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
            ),
            Text(
              "Made By: ${project.madeBy}",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize:
                    MediaQuery.of(context).size.width > 600 ? 20.sp : 16.sp,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 10.sp : 5.sp,
            ),
            Text(
              DateFormat('dd MMMM yyyy').format(project.date),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize:
                    MediaQuery.of(context).size.width > 600 ? 18.sp : 14.sp,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
            ),
            Wrap(
              spacing: MediaQuery.of(context).size.width > 600 ? 10.sp : 5.sp,
              runSpacing:
                  MediaQuery.of(context).size.width > 600 ? 10.sp : 5.sp,
              children:
                  project.tags.map((tag) => _buildTag(context, tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 120.sp : 60.sp,
        vertical: MediaQuery.of(context).size.width > 600 ? 60.sp : 30.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project Description",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: MediaQuery.of(context).size.width > 600 ? 40.sp : 24.sp,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
          ),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: MediaQuery.of(context).size.width > 600 ? 24.sp : 16.sp,
            ),
          ),
          if (project.imageUrls != null && project.imageUrls!.isNotEmpty) ...[
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 40.sp : 20.sp,
            ),
            Text(
              "Images",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: WebsiteColors.primaryBlueColor,
                fontSize:
                    MediaQuery.of(context).size.width > 600 ? 40.sp : 24.sp,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 400.sp : 300.sp,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: project.imageUrls!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right:
                          MediaQuery.of(context).size.width > 600
                              ? 20.sp
                              : 10.sp,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => Dialog(
                                child: InteractiveViewer(
                                  child: Image.network(
                                    project.imageUrls![index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width > 600
                              ? 20.sp
                              : 10.sp,
                        ),
                        child: Image.network(
                          project.imageUrls![index],
                          fit: BoxFit.cover,
                          width:
                              MediaQuery.of(context).size.width > 600
                                  ? 400.sp
                                  : 300.sp,
                          height:
                              MediaQuery.of(context).size.width > 600
                                  ? 400.sp
                                  : 300.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          if (project.additionalDetails != null &&
              project.additionalDetails!.isNotEmpty) ...[
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 40.sp : 20.sp,
            ),
            Text(
              "Additional Details",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: WebsiteColors.primaryBlueColor,
                fontSize:
                    MediaQuery.of(context).size.width > 600 ? 40.sp : 24.sp,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
            ),
            ...project.additionalDetails!.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).size.width > 600 ? 10.sp : 5.sp,
                ),
                child: Row(
                  children: [
                    Text(
                      "${entry.key.replaceAll('_', ' ').toUpperCase()}: ",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: WebsiteColors.primaryBlueColor,
                        fontSize:
                            MediaQuery.of(context).size.width > 600
                                ? 18.sp
                                : 14.sp,
                      ),
                    ),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.width > 600
                                ? 18.sp
                                : 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
        vertical: MediaQuery.of(context).size.width > 600 ? 10.sp : 5.sp,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
        ),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width > 600 ? 18.sp : 14.sp,
        ),
      ),
    );
  }
}
