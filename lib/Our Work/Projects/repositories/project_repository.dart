import '../models/project_model.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects({int limit = 6, String? lastProjectId});
  Future<List<Project>> searchProjects(String query);
  Future<List<Project>> getProjectsByTag(String tag);
  Future<Project?> getProjectById(String id);
}

class FirebaseProjectRepository implements ProjectRepository {
  // TODO: Add Firebase initialization and configuration
  
  @override
  Future<List<Project>> getProjects({int limit = 6, String? lastProjectId}) async {
    // TODO: Implement Firebase Firestore query with proper pagination
    // Example implementation:
    /*
    Query query = FirebaseFirestore.instance
        .collection('projects')
        .orderBy('date', descending: true)
        .limit(limit);

    if (lastProjectId != null) {
      final lastDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(lastProjectId)
          .get();
      query = query.startAfterDocument(lastDoc);
    }

    final QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Project.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    */
    
    // Temporary mock data with multiple categories
    return List.generate(
      limit,
      (index) => Project(
        id: 'project-$index',
        title: 'Project ${index + 1}',
        description: 'This is a sample project description for project ${index + 1}',
        madeBy: 'IEEE Members',
        date: DateTime.now().subtract(Duration(days: index)),
        tags: [
          ['AI', 'Machine Learning', 'Data Science'],
          ['Robotics', 'IoT', 'Hardware'],
          ['Web Development', 'Mobile Apps', 'UI/UX'],
          ['Embedded Systems', 'IoT', 'Hardware'],
          ['Cloud Computing', 'Web Development', 'Backend'],
          ['Computer Vision', 'AI', 'Image Processing'],
        ][index % 6],
        imageUrl: 'assets/project_placeholder.jpg',
        additionalDetails: {
          'status': 'Completed',
          'team_size': '5 members',
          'duration': '3 months',
        },
      ),
    );
  }

  @override
  Future<List<Project>> searchProjects(String query) async {
    if (query.isEmpty) {
      return getProjects();
    }

    // TODO: Implement Firebase search query
    // For optimal performance, consider using a search service like Algolia
    // Example implementation:
    /*
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .where('searchTokens', arrayContains: query.toLowerCase())
        .get();

    return snapshot.docs
        .map((doc) => Project.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    */

    // For now, fetch all projects and filter in memory
    final allProjects = await getProjects(limit: 50);
    return allProjects.where((project) => project.matchesSearch(query)).toList();
  }

  @override
  Future<List<Project>> getProjectsByTag(String tag) async {
    // TODO: Implement Firebase tag query
    // Example implementation:
    /*
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .where('tags', arrayContains: tag)
        .get();

    return snapshot.docs
        .map((doc) => Project.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    */

    // For now, fetch all projects and filter by tag
    final allProjects = await getProjects(limit: 50);
    return allProjects.where((project) => project.tags.contains(tag)).toList();
  }

  @override
  Future<Project?> getProjectById(String id) async {
    // TODO: Implement Firebase get by ID
    // Example implementation:
    /*
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('projects')
        .doc(id)
        .get();

    if (!doc.exists) return null;
    return Project.fromJson(doc.data() as Map<String, dynamic>);
    */
    return null;
  }
}
