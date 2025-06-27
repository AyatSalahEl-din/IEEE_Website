import 'package:flutter/material.dart';
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
          20,
        ),
      ),
      child: Container(
        width: 800,
        padding: EdgeInsets.all(
          30,
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
                        MediaQuery.of(context).size.width < 600 ?20:40,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size:
                        MediaQuery.of(context).size.width < 600 ?18:24,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
                         20,
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
                              15,
                            ),
                            boxShadow: [
                              if (isHovered || isClicked)
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius:
                                     15,
                                  spreadRadius:
                                      5,
                                ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius:
                                    10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              15,
                            ),
                            child: Row(
                              children: [
                                if (project.imageUrls != null &&
                                    project.imageUrls!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    child: Image.network(
                                      project.imageUrls!.first,
                                      width:
                                         100,
                                      height:
                                          100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Container(
                                    width:
                                       100,
                                    height:
                                        100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No Image",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize:
                                              MediaQuery.of(context).size.width < 600 ?12:14,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  width:
                                     15,
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
                                            MediaQuery.of(context).size.width < 600 ?14:18,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                           5,
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
                                             16,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            5,
                                      ),
                                      Text(
                                        "Date: ${DateFormat('dd MMM yyyy').format(project.date)}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.copyWith(
                                          color: Colors.grey[600],
                                          fontSize:
                                            MediaQuery.of(context).size.width < 600 ?12:14,
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
