import 'package:flutter/material.dart';
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
          horizontal: 120,
          vertical: 60,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: MediaQuery.of(context).size.width < 600 ?16:24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              project.title,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize:
                     MediaQuery.of(context).size.width < 600 ?18:36,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Made By: ${project.madeBy}",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize:
                  MediaQuery.of(context).size.width < 600 ?18:20,
              ),
            ),
            SizedBox(
              height:10,
            ),
            Text(
              DateFormat('dd MMMM yyyy').format(project.date),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize:
                     MediaQuery.of(context).size.width < 600 ?16:18,
              ),
            ),
            SizedBox(
              height:20,
            ),
            Wrap(
              spacing: 10,
              runSpacing:
                 10,
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
        horizontal: 120,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project Description",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize:  MediaQuery.of(context).size.width < 600 ?20:40,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 24,
            ),
          ),
          if (project.imageUrls != null && project.imageUrls!.isNotEmpty) ...[
            SizedBox(
              height: 40,
            ),
            Text(
              "Images",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: WebsiteColors.primaryBlueColor,
                fontSize:
                    MediaQuery.of(context).size.width < 600 ?20:40,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: project.imageUrls!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right:
                          20,
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
                         20,
                        ),
                        child: Image.network(
                          project.imageUrls![index],
                          fit: BoxFit.cover,
                          width:
                              400,
                          height:
                             400,
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
              height: 40,
            ),
            Text(
              "Additional Details",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: WebsiteColors.primaryBlueColor,
                fontSize:
                     MediaQuery.of(context).size.width < 600 ?20:40,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ...project.additionalDetails!.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  bottom:
                      10,
                ),
                child: Row(
                  children: [
                    Text(
                      "${entry.key.replaceAll('_', ' ').toUpperCase()}: ",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: WebsiteColors.primaryBlueColor,
                        fontSize:
                           MediaQuery.of(context).size.width < 600 ?16:18,
                      ),
                    ),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize:
                           MediaQuery.of(context).size.width < 600 ?16:18,
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
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width < 600 ?16:18,
        ),
      ),
    );
  }
}
