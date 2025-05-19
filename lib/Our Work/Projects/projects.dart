import 'dart:async';
import 'dart:math' as Math;
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

  const Projects({Key? key, this.tabController}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late VideoPlayerController _videoController;
  final ProjectRepository _projectRepository = FirebaseProjectRepository();

  List<Project> _projects = [];
  List<Project> _originalProjects = []; // New list to store original projects
  bool _isLoading = false;
  String? _lastProjectId;
  List<double> projectOpacities = [];
  Timer? _searchDebounce;
  String _lastSearchQuery = '';
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
        _videoController.setLooping(true);
        setState(() {});
      });

    _loadInitialProjects();
    _setupScrollListener();
  }

  Future<void> _loadInitialProjects() async {
    setState(() => _isLoading = true);
    try {
      final projects = await _projectRepository.getProjects();
      _originalProjects = List.from(projects); // Store original projects
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
    _scrollController.addListener(() {
      double currentScroll = _scrollController.position.pixels;
      double viewportHeight = MediaQuery.of(context).size.height;

      setState(() {
        for (int i = 1; i < _projects.length; i++) {
          double projectPosition = (i * 500.sp) + 600.sp;
          double fadeStart = projectPosition - viewportHeight;
          double fadeEnd = projectPosition - (viewportHeight * 0.4);

          if (currentScroll >= fadeStart && currentScroll <= fadeEnd) {
            double progress =
                (currentScroll - fadeStart) / (fadeEnd - fadeStart);
            double easedProgress = Math.pow(progress, 2.0).toDouble();
            projectOpacities[i] = easedProgress.clamp(0.0, 1.0);
          } else if (currentScroll > fadeEnd) {
            projectOpacities[i] = 1.0;
          } else {
            projectOpacities[i] = 0.0;
          }
        }
      });
    });
  }

  Future<void> _handleSearch(String query) async {
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce!.cancel();
    }

    // Don't search if query hasn't changed
    if (query == _lastSearchQuery && _selectedCategory == null) return;
    _lastSearchQuery = query;

    _searchDebounce = Timer(Duration(milliseconds: 500), () async {
      setState(() => _isLoading = true);
      try {
        List<Project> results;
        if (query.isEmpty && _selectedCategory == null) {
          // Retrieve all projects in original order
          results = List.from(_originalProjects);
        } else {
          results = await _projectRepository.searchProjects(query);
          if (_selectedCategory != null) {
            results =
                results
                    .where(
                      (project) => project.tags.contains(_selectedCategory),
                    )
                    .toList();
          }
        }
        setState(() {
          _projects = results;
          projectOpacities = List.generate(results.length, (index) => 1.0);
          _isSelected = List.generate(results.length, (index) => false);
          _isHovered = List.generate(results.length, (index) => false);
        });
      } catch (e) {
        print('Error searching projects: $e');
      } finally {
        setState(() => _isLoading = false);
      }
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
            // No filter applied, load all projects
            _projects.addAll(newProjects);
          } else {
            // Filter projects based on the selected category
            final filteredProjects =
                newProjects
                    .where(
                      (project) => project.tags.contains(_selectedCategory),
                    )
                    .toList();
            _projects.addAll(filteredProjects);
          }
          _lastProjectId = newProjects.last.id;
          projectOpacities.addAll(
            List.generate(newProjects.length, (index) => 0.0),
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
        Container(
          width: double.infinity,
          height: 500.sp,
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
                          height: 500.sp,
                          width: 500.sp * _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    ),
                  )
                  : Container(color: const Color.fromARGB(180, 16, 15, 14)),
        ),
        Container(
          width: double.infinity,
          height: 500.sp,
          color: Colors.black.withOpacity(0.5),
        ),
        Container(
          width: double.infinity,
          height: 500.sp,
          padding: EdgeInsets.symmetric(horizontal: 100.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 900.sp,
                child: Text(
                  "Discover our innovative projects and research work",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: WebsiteColors.whiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40.sp),
              _buildSearchBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 600.sp,
      decoration: BoxDecoration(
        color: WebsiteColors.whiteColor,
        borderRadius: BorderRadius.circular(30.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 20.sp,
        ),
        onChanged: _handleSearch,
        decoration: InputDecoration(
          hintText: "Search by project name, category, or features...",
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontSize: 20.sp,
          ),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 25.sp,
            vertical: 15.sp,
          ),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _handleSearch('');
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 120.sp),
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
                            _currentCategoryIndex -= 6;
                          });
                        }
                        : null,
              ),
              _buildGradientButton('All'), // Add "All" button
              ...List.generate(6, (index) {
                int categoryIndex = _currentCategoryIndex + index;
                if (categoryIndex < _allCategories.length) {
                  return _buildGradientButton(_allCategories[categoryIndex]);
                } else {
                  return SizedBox.shrink();
                }
              }),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed:
                    _currentCategoryIndex + 6 < _allCategories.length
                        ? () {
                          setState(() {
                            _currentCategoryIndex += 6;
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
    return Padding(
      padding: EdgeInsets.only(right: 10.sp),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category == 'All' ? null : category;
            _searchController.clear();
            if (_selectedCategory == null) {
              _projects = List.from(
                _originalProjects,
              ); // Reset to original projects
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
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color:
                  isSelected
                      ? WebsiteColors.whiteColor
                      : WebsiteColors.greyColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    if (_isLoading && _projects.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (_projects.isEmpty) {
      return ComingSoonWidget(message: "No projects found!");
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 120.sp, vertical: 100.sp),
      child: Column(
        children: [
          ...List.generate(_projects.length, (index) {
            return _buildProjectItem(index);
          }),
          SizedBox(height: 40.sp), // Add space between projects and the button
          if (_isLoading) CircularProgressIndicator(),
          if (!_isLoading && _lastProjectId != null) _buildLoadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 60.sp,
      ), // Add space between button and bottom
      child: StatefulBuilder(
        builder: (context, setState) {
          bool isClicked = false;

          return GestureDetector(
            onTapDown: (_) => setState(() => isClicked = true),
            onTapUp: (_) => setState(() => isClicked = false),
            onTapCancel: () => setState(() => isClicked = false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 200.sp, // Ensure shadow matches button width
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WebsiteColors.primaryBlueColor.withOpacity(0.8),
                    WebsiteColors.primaryBlueColor.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(
                  isClicked ? 40.sp : 30.sp,
                ), // Animate border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(
                      isClicked ? 0.7 : 0.5,
                    ), // Dynamic shadow intensity
                    blurRadius: isClicked ? 10 : 5, // Animate blur radius
                    spreadRadius: isClicked ? 3 : 1, // Animate spread radius
                    offset: Offset(
                      0,
                      isClicked ? 4 : 2,
                    ), // Animate shadow offset
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : loadMoreProjects,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  elevation: 0,
                  backgroundColor:
                      Colors.transparent, // Transparent for gradient
                  shadowColor: Colors.transparent,
                ),
                child:
                    _isLoading
                        ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: CircularProgressIndicator(
                            color: WebsiteColors.whiteColor,
                          ),
                        )
                        : Text(
                          "See More",
                          style: TextStyle(
                            color: WebsiteColors.whiteColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectItem(int index) {
    bool isEven = index % 2 == 0;
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: projectOpacities[index],
      child: Padding(
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
                    _isSelected[index]
                        ? [
                          BoxShadow(
                            color: WebsiteColors.primaryBlueColor.withOpacity(
                              0.5,
                            ),
                            blurRadius: 15,
                            spreadRadius: 15,
                          ),
                        ]
                        : _isHovered[index]
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
      constraints: BoxConstraints(minHeight: 300.sp),
      margin: EdgeInsets.only(left: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: WebsiteColors.primaryBlueColor,
            ),
          ),
          SizedBox(height: 20.sp),
          Text(
            "Made By: ${project.madeBy}",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: WebsiteColors.primaryBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 20.sp),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              height: 1.5,
              color: WebsiteColors.darkBlueColor,
              fontSize: 28.sp,
            ),
            maxLines: 3,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: 15.sp),
          Text(
            "Date: ${DateFormat('dd MMMM yyyy').format(project.date)}",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.grey[700],
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 20.sp),
          Wrap(
            spacing: 10.sp,
            runSpacing: 10.sp,
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeroSection(),
            SizedBox(height: 20.sp),
            _buildCategoryFilter(),
            SizedBox(height: 20.sp),
            _buildProjectsSection(),
            if (widget.tabController != null)
              Footer(tabController: widget.tabController!),
          ],
        ),
      ),
    );
  }
}
