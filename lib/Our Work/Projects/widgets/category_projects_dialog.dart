import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import '../models/project_model.dart';
import '../pages/project_details_page.dart';

class CategoryProjectsDialog extends StatelessWidget {
  final String category;
  final List<Project> projects;

  const CategoryProjectsDialog({
    Key? key,
    required this.category,
    required this.projects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Container(
        width: 800.sp,
        padding: EdgeInsets.all(30.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$category Projects',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: WebsiteColors.primaryBlueColor,
                    fontWeight: FontWeight.bold,fontSize: 40.sp
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 20.sp),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsPage(
                            project: project,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.sp),
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100.sp,
                            height: 100.sp,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                          ),
                          SizedBox(width: 20.sp),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.title,
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color:WebsiteColors.darkBlueColor,
                                    fontWeight: FontWeight.bold,fontSize:36.sp
                                  ),
                                ),
                                SizedBox(height: 10.sp),
                                Text(
                                  project.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color:WebsiteColors.darkGreyColor,
                                    fontSize: 25.sp,fontWeight:FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16.sp),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
