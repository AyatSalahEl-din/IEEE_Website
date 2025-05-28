import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_website/Our%20Work/Projects/models/project_model.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects({int limit = 6, String? lastProjectId});
  Future<List<Project>> searchProjects(String query);
  Future<List<Project>> getProjectsByTag(String tag);
  Future<Project?> getProjectById(String id);
}

class FirebaseProjectRepository implements ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Project>> getProjects({
    int limit = 4,
    String? lastProjectId,
  }) async {
    Query query = _firestore
        .collection('projects')
        .orderBy('date', descending: true)
        .limit(limit);

    if (lastProjectId != null) {
      final lastDoc =
          await _firestore.collection('projects').doc(lastProjectId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) {
          try {
            return Project.fromFirestore(
              doc.data() as Map<String, dynamic>, // Extract data as Map
              doc.id, // Pass document ID
            );
          } catch (e) {
            print('Error parsing project document: ${doc.id}, error: $e');
            return null;
          }
        })
        .whereType<Project>()
        .toList(); // Filter out null values
  }

  @override
  Future<List<Project>> searchProjects(String query) async {
    if (query.isEmpty) {
      return getProjects();
    }

    final lowerCaseQuery = query.toLowerCase();

    final QuerySnapshot snapshot =
        await _firestore
            .collection('projects')
            .get(); // Fetch all projects to filter locally

    return snapshot.docs
        .map((doc) {
          try {
            final project = Project.fromFirestore(
              doc.data() as Map<String, dynamic>, // Extract data as Map
              doc.id, // Pass document ID
            );

            // Check if the query matches the name, category, or description
            if (project.title.toLowerCase().contains(lowerCaseQuery) ||
                project.description.toLowerCase().contains(lowerCaseQuery) ||
                project.tags.any(
                  (tag) => tag.toLowerCase().contains(lowerCaseQuery),
                )) {
              return project;
            }
            return null;
          } catch (e) {
            print('Error parsing project document: ${doc.id}, error: $e');
            return null;
          }
        })
        .whereType<Project>()
        .toList();
  }

  @override
  Future<List<Project>> getProjectsByTag(String tag) async {
    final QuerySnapshot snapshot =
        await _firestore
            .collection('projects')
            .where('tags', arrayContains: tag)
            .get();

    return snapshot.docs
        .map((doc) {
          try {
            return Project.fromFirestore(
              doc.data() as Map<String, dynamic>, // Extract data as Map
              doc.id, // Pass document ID
            );
          } catch (e) {
            print('Error parsing project document: ${doc.id}, error: $e');
            return null;
          }
        })
        .whereType<Project>()
        .toList(); // Filter out null values
  }

  @override
  Future<Project?> getProjectById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection('projects').doc(id).get();
    if (doc.exists) {
      try {
        return Project.fromFirestore(
          doc.data() as Map<String, dynamic>, // Extract data as Map
          doc.id, // Pass document ID
        );
      } catch (e) {
        print('Error parsing project document: ${doc.id}, error: $e');
      }
    }
    return null;
  }
}

// Ensure all sizes have .sp applied
// Ensure any future UI-related elements in this repository follow responsive design principles.
