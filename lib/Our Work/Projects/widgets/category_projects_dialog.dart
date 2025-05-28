import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Our Work/Projects/pages/project_details_page.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:intl/intl.dart';
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
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width > 600 ? 20.sp : 12.sp,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 800.sp : 400.sp,
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width > 600 ? 30.sp : 20.sp,
        ),
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
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width > 600 ? 40.sp : 24.sp,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size:
                        MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
            ),
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
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(context).size.width > 600
                              ? 20.sp
                              : 10.sp,
                    ),
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
                              builder:
                                  (context) =>
                                      ProjectDetailsPage(project: project),
                            ),
                          ).then((_) {
                            setState(() {
                              _clickedIndex = null;
                            });
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width > 600
                                  ? 15.sp
                                  : 10.sp,
                            ),
                            boxShadow: [
                              if (isHovered || isClicked)
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius:
                                      MediaQuery.of(context).size.width > 600
                                          ? 15.sp
                                          : 10.sp,
                                  spreadRadius:
                                      MediaQuery.of(context).size.width > 600
                                          ? 5.sp
                                          : 3.sp,
                                ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius:
                                    MediaQuery.of(context).size.width > 600
                                        ? 10.sp
                                        : 6.sp,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width > 600
                                  ? 15.sp
                                  : 10.sp,
                            ),
                            child: Row(
                              children: [
                                if (project.imageUrls != null &&
                                    project.imageUrls!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width > 600
                                          ? 10.sp
                                          : 8.sp,
                                    ),
                                    child: Image.network(
                                      project.imageUrls!.first,
                                      width:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 100.sp
                                              : 80.sp,
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 100.sp
                                              : 80.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width > 600
                                            ? 100.sp
                                            : 80.sp,
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? 100.sp
                                            : 80.sp,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width > 600
                                            ? 10.sp
                                            : 8.sp,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No Image",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize:
                                              MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      600
                                                  ? 14.sp
                                                  : 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width > 600
                                          ? 15.sp
                                          : 10.sp,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project.title,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize:
                                              MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      600
                                                  ? 18.sp
                                                  : 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 5.sp
                                                : 3.sp,
                                      ),
                                      Text(
                                        project.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.copyWith(
                                          color: Colors.grey[700],
                                          fontSize:
                                              MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      600
                                                  ? 16.sp
                                                  : 12.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 5.sp
                                                : 3.sp,
                                      ),
                                      Text(
                                        "Date: ${DateFormat('dd MMM yyyy').format(project.date)}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.copyWith(
                                          color: Colors.grey[600],
                                          fontSize:
                                              MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      600
                                                  ? 14.sp
                                                  : 12.sp,
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
