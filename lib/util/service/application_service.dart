import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> createApplication(Map<String, dynamic> applicationData) async {
    await _firestore.collection('users').doc(userId).collection('applications').add(applicationData);
  }

  Future<Object?> fetchUserProfile() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data();
  }

  Future<List<Map<String, dynamic>>> fetchApplications() async {
    final querySnapshot = await _firestore.collection('users').doc(userId).collection('applications').get();
    return querySnapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  Future<void> deleteApplication(String applicationId) async {
    await _firestore.collection('users').doc(userId).collection('applications').doc(applicationId).delete();
  }

  Future<Map<String, dynamic>?> fetchMostRecentApplication() async {
    final querySnapshot = await _firestore.collection('users').doc(userId).collection('applications')
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null;
    }
  }

  Future<void> updateTask(String applicationId, Map<String, dynamic> updatedTask) async {
    var applicationRef = _firestore.collection('users').doc(userId).collection('applications').doc(applicationId);
    var applicationSnapshot = await applicationRef.get();
    var tasks = List<Map<String, dynamic>>.from(applicationSnapshot.data()?['tasks']);

    var taskIndex = tasks.indexWhere((task) => task['title'] == updatedTask['title']);
    if (taskIndex != -1) {
      tasks[taskIndex] = updatedTask;
    }

    await applicationRef.update({'tasks': tasks});
  }

  Future<List<Map<String, dynamic>>> fetchTasks(String applicationId) async {
    // final querySnapshot = await _firestore.collection('users').doc(userId).collection('applications').doc(applicationId).collection('tasks').get();
    final querySnapshot = await _firestore.collection('users').doc(userId).collection('applications').doc(applicationId).get();
    var data = querySnapshot.data();
    // print(querySnapshot.docs);
    return List<Map<String, dynamic>>.from(data?['tasks']);
  }
}
