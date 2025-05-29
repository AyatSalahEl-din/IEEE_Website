import 'dart:async';
//port 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Widgets/footer.dart';
import 'package:ieee_website/widgets/coming_soon_widget.dart';
import 'package:video_player/video_player.dart';
import 'models/project_model.dart';
import 'repositories/project_repository.dart';
import 'package:intl/intl.dart';
import 'widgets/category_projects_dialog.dart';
import 'pages/project_details_page.dart';

class Projects extends StatefulWidget {
  static const String routeName = 'projects';
  final TabController? tabController;

  const Projects({super.key, this.tabController});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late VideoPlayerController _videoController;
  final ProjectRepository _projectRepository = FirebaseProjectRepository();

  List<Project> _projects = [];
  List<Project> _originalProjects = [];
  bool _isLoading = false;
  String? _lastProjectId;
  List<double> projectOpacities = [];
  Timer? _searchDebounce;
  List<String> _allCategories = [];
  String? _selectedCategory;
  int _currentCategoryIndex = 0;
  List<bool> _isSelected = [];
  List<bool> _isHovered = [];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
        'assets/images/projectshero.mp4',
      )
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true); // Enable looping
        setState(() {});
      });

    _loadInitialProjects();
    _setupScrollListener();
  }

  Future<void> _loadInitialProjects() async {
    setState(() => _isLoading = true);
    try {
      final projects = await _projectRepository.getProjects();
      _originalProjects = List.from(projects);
      setState(() {
        _projects = projects;
        projectOpacities = List.generate(
          projects.length,
          (index) => index == 0 ? 1.0 : 0.0,
        );
        _isSelected = List.generate(projects.length, (index) => false);
        _isHovered = List.generate(projects.length, (index) => false);
        if (projects.isNotEmpty) {
          _lastProjectId = projects.last.id;
        }
        // Extract unique categories from all projects
        _allCategories =
            projects.expand((project) => project.tags).toSet().toList()..sort();
      });
    } catch (e) {
      print('Error loading projects: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _setupScrollListener() {
    // Remove fading logic by not modifying projectOpacities
    _scrollController.addListener(() {
      setState(() {}); // Only update the state without opacity logic
    });
  }

  Future<void> loadMoreProjects() async {
    if (_isLoading || _lastProjectId == null) return;

    setState(() => _isLoading = true);
    try {
      final newProjects = await _projectRepository.getProjects(
        lastProjectId: _lastProjectId,
      );

      if (newProjects.isNotEmpty) {
        setState(() {
          if (_selectedCategory == null) {
            _projects.addAll(newProjects);
          } else {
            final filteredProjects =
                newProjects
                    .where(
                      (project) => project.tags.contains(_selectedCategory),
                    )
                    .toList();
            _projects.addAll(filteredProjects);
          }
          _lastProjectId = newProjects.last.id;

          // Ensure the first project after "See More" is not blurred
          projectOpacities.addAll(
            List.generate(
              newProjects.length,
              (index) => index == 0 ? 1.0 : 0.0,
            ),
          );
          _isSelected.addAll(
            List.generate(newProjects.length, (index) => false),
          );
          _isHovered.addAll(
            List.generate(newProjects.length, (index) => false),
          );
        });
      }
    } catch (e) {
      print('Error loading more projects: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width > 600 ? 500.sp : 300.sp,
          child:
              _videoController.value.isInitialized
                  ? ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      maxHeight: double.infinity,
                      maxWidth: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).size.width > 600
                                  ? 500.sp
                                  : 300.sp,
                          width:
                              (MediaQuery.of(context).size.width > 600
                                  ? 500.sp
                                  : 300.sp) *
                              _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    ),
                  )
                  : Container(color: const Color.fromARGB(180, 16, 15, 14)),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width > 600 ? 500.sp : 300.sp,
          color: Colors.black.withOpacity(0.5),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width > 600 ? 500.sp : 300.sp,
          padding: EdgeInsets.symmetric(
            horizontal:
                MediaQuery.of(context).size.width > 600 ? 100.sp : 50.sp,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:
                    MediaQuery.of(context).size.width > 600 ? 900.sp : 600.sp,
                child: Text(
                  "Discover our innovative projects and research work",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: WebsiteColors.whiteColor,
                    fontSize:
                        MediaQuery.of(context).size.width > 600 ? 28.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width > 600 ? 40.sp : 20.sp,
              ),
              _buildSearchBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double searchBarWidth =
            constraints.maxWidth > 800.sp ? 600.sp : constraints.maxWidth * 0.8;

        return Container(
          width: searchBarWidth,
          height: 50.sp,
          decoration: BoxDecoration(
            color: WebsiteColors.whiteColor,
            borderRadius: BorderRadius.circular(25.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              onChanged: (value) {
                setState(() {
                  _projects =
                      _originalProjects.where((project) {
                        return project.title.toLowerCase().contains(
                              value.toLowerCase(),
                            ) ||
                            project.tags.any(
                              (tag) => tag.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                            );
                      }).toList();
                });
              },
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16.sp,
                color: WebsiteColors.primaryBlueColor,
              ),
              decoration: InputDecoration(
                hintText: "Search Projects, Categories, Features...",
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16.sp,
                  color: WebsiteColors.primaryBlueColor.withOpacity(0.7),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.sp,
                  color: WebsiteColors.primaryBlueColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.sp),
                  borderSide: BorderSide(color: WebsiteColors.primaryBlueColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.sp),
                  borderSide: BorderSide(
                    color: WebsiteColors.primaryBlueColor,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.sp,
                  horizontal: 10.sp,
                ),
                isCollapsed: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 80.sp),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed:
                    _currentCategoryIndex > 0
                        ? () {
                          setState(() {
                            _currentCategoryIndex -=
                                1; // Show the previous category
                          });
                        }
                        : null,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: _buildGradientButton('All'), // Add "All" filter
              ),
              ...List.generate(4, (index) {
                int categoryIndex = _currentCategoryIndex + index;
                if (categoryIndex < _allCategories.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: _buildGradientButton(_allCategories[categoryIndex]),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed:
                    _currentCategoryIndex + 4 < _allCategories.length
                        ? () {
                          setState(() {
                            _currentCategoryIndex +=
                                1; // Show the next category
                          });
                        }
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String? category) {
    bool isSelected =
        _selectedCategory == category ||
        (category == 'All' && _selectedCategory == null);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category == 'All' ? null : category;
          _searchController.clear();
          if (_selectedCategory == null) {
            _projects = List.from(_originalProjects); // Reset to all projects
          } else {
            _projects =
                _originalProjects
                    .where(
                      (project) => project.tags.contains(_selectedCategory),
                    )
                    .toList();
          }
          projectOpacities = List.generate(_projects.length, (index) => 1.0);
          _isSelected = List.generate(_projects.length, (index) => false);
          _isHovered = List.generate(_projects.length, (index) => false);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [
                      WebsiteColors.primaryYellowColor,
                      const Color.fromARGB(255, 255, 230, 190),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(colors: [Colors.white, Colors.white]),
          borderRadius: BorderRadius.circular(30.sp),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: WebsiteColors.greyColor.withOpacity(0.1),
                blurRadius: 2,
                spreadRadius: 0.5,
              ),
          ],
        ),
        child: Text(
          category ?? 'All',
          style: TextStyle(
            fontSize: 20.sp, // Updated size
            fontWeight: FontWeight.bold,
            color:
                isSelected ? WebsiteColors.whiteColor : WebsiteColors.greyColor,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    if (_isLoading && _projects.isEmpty) {
      return Center(child: _buildFlickeringDots()); // Use flickering dots
    }

    if (_projects.isEmpty) {
      return ComingSoonWidget(message: "No projects found!");
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 120.sp, vertical: 100.sp),
      child: Column(
        children: [
          ...List.generate(_projects.length, (index) {
            return _buildProjectItem(index); // Directly display projects
          }),
          SizedBox(height: 40.sp),
          if (_isLoading) _buildFlickeringDots(), // Use flickering dots
          if (!_isLoading && _lastProjectId != null) _buildLoadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildFlickeringDots() {
    return SizedBox(
      height: 50.sp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 5.sp),
            width: 10.sp,
            height: 10.sp,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(index == 0 ? 0.3 : 0.6),
              shape: BoxShape.circle,
            ),
            onEnd: () {
              setState(() {});
            },
          );
        }),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width > 600 ? 60.sp : 30.sp,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(
            MediaQuery.of(context).size.width > 600 ? 250.sp : 250.sp,
            MediaQuery.of(context).size.height > 600 ? 50.sp : 30.sp,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.sp),
          ),
          backgroundColor: WebsiteColors.primaryBlueColor,
        ),
        onPressed: _isLoading ? null : loadMoreProjects,
        child: Center(
          child: Text(
            "See More",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 18.sp : 14.sp,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectItem(int index) {
    bool isEven = index % 2 == 0;
    return Padding(
      padding: EdgeInsets.only(bottom: 100.sp),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered[index] = true),
        onExit: (_) => setState(() => _isHovered[index] = false),
        child: InkWell(
          onTap: () => _navigateToProjectDetails(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              color: Colors.white,
              boxShadow:
                  _isHovered[index]
                      ? [
                        BoxShadow(
                          color: WebsiteColors.primaryBlueColor.withOpacity(
                            0.2,
                          ),
                          blurRadius: 15,
                          spreadRadius: 15,
                        ),
                      ]
                      : [],
            ),
            child: Padding(
              padding: EdgeInsets.all(30.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isEven) _buildProjectImage(_projects[index]),
                  if (isEven) SizedBox(width: 60.sp),
                  Expanded(child: _buildProjectContent(_projects[index])),
                  if (!isEven) SizedBox(width: 60.sp),
                  if (!isEven) _buildProjectImage(_projects[index]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProjectDetails(int index) {
    setState(() {
      _isSelected[index] = true;
      // Reset other selections
      for (int i = 0; i < _isSelected.length; i++) {
        if (i != index) _isSelected[i] = false;
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsPage(project: _projects[index]),
      ),
    ).then((_) {
      setState(() => _isSelected[index] = false);
    });
  }

  Widget _buildProjectImage(Project project) {
    return Container(
      width: 500.sp,
      height: 300.sp,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        image:
            project.imageUrls != null && project.imageUrls!.isNotEmpty
                ? DecorationImage(
                  image: NetworkImage(project.imageUrls!.first),
                  fit: BoxFit.cover,
                )
                : DecorationImage(
                  image: AssetImage('assets/images/n.png'), // Static image
                  fit: BoxFit.cover,
                ),
      ),
    );
  }

  Widget _buildProjectContent(Project project) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width > 600 ? 300.sp : 200.sp,
      ),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: WebsiteColors.primaryBlueColor,
              fontSize: MediaQuery.of(context).size.width > 600 ? 24.sp : 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
          ),
          Text(
            "Made By: ${project.madeBy}",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: WebsiteColors.primaryBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width > 600 ? 20.sp : 16.sp,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
          ),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              height: 1.5,
              color: WebsiteColors.darkBlueColor,
              fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 15.sp : 10.sp,
          ),
          Text(
            "Date: ${DateFormat('dd MMMM yyyy').format(project.date)}",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.grey[700],
              fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 20.sp : 10.sp,
          ),
          Wrap(
            spacing: MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
            runSpacing: MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
            children:
                project.tags.map((tag) => _buildTag(tag, project)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Project currentProject) {
    return InkWell(
      onTap: () {
        // Filter projects with the same tag
        final projectsWithTag =
            _projects.where((project) => project.tags.contains(text)).toList();

        showDialog(
          context: context,
          builder:
              (context) => CategoryProjectsDialog(
                category: text,
                projects: projectsWithTag,
              ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color: WebsiteColors.primaryYellowColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            color: WebsiteColors.primaryYellowColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          // Header Section
                          _buildHeroSection(),
                          SizedBox(height: 20.sp),
                          // Content Section
                          _buildCategoryFilter(),
                          SizedBox(height: 20.sp),
                          _buildProjectsSection(),
                          SizedBox(height: 20.sp),
                        ],
                      ),
                    ),
                    if (widget.tabController != null)
                      Footer(tabController: widget.tabController!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
