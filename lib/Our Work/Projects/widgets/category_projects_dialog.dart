import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Our Work/Projects/pages/project_details_page.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import '../models/project_model.dart';

class CategoryProjectsDialog extends StatefulWidget {
  final String category;
  final List<Project> projects;

  const CategoryProjectsDialog({
    Key? key,
    required this.category,
    required this.projects,
  }) : super(key: key);

  @override
  State<CategoryProjectsDialog> createState() => _CategoryProjectsDialogState();
}

class _CategoryProjectsDialogState extends State<CategoryProjectsDialog> {
  int? _hoveredIndex;
  int? _clickedIndex;

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
              "Projects in ${widget.category}",
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
                itemCount: widget.projects.length,
                itemBuilder: (context, index) {
                  final project = widget.projects[index];
                  final isHovered = _hoveredIndex == index;
                  final isClicked = _clickedIndex == index;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.sp),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _hoveredIndex = index;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _hoveredIndex = null;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _clickedIndex = index;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailsPage(
                                project: project,
                              ),
                            ),
                          ).then((_) {
                            setState(() {
                              _clickedIndex = null;
                            });
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.sp),
                            boxShadow: [
                              if (isHovered || isClicked)
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.sp),
                            child: Row(
                              children: [
                                if (project.imageUrls != null &&
                                    project.imageUrls!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    child: Image.network(
                                      project.imageUrls!.first,
                                      width: 100.sp,
                                      height: 100.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Container(
                                    width: 100.sp,
                                    height: 100.sp,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10.sp),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No Image",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 15.sp),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                      ),
                                      SizedBox(height: 5.sp),
                                      Text(
                                        project.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.grey[700],
                                            ),
                                      ),
                                      SizedBox(height: 5.sp),
                                      Text(
                                        "Date: ${project.date.toLocal()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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