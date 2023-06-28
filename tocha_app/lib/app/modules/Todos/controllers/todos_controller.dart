import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TodosController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Todos> todos = <Todos>[].obs;
  RxList<Map<String, dynamic>> users = RxList<Map<String, dynamic>>([]);

  User? get currentUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() async {
    try {
      if (currentUser != null) {
        final userId = currentUser!.uid;
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('todos')
            .get();
        todos.value = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final dateTime = (data['dateTime'] as Timestamp).toDate();
          return Todos.fromSnapshot(doc, dateTime);
        }).toList();
      }
    } catch (error) {
      print(error);
    }
  }

  void createTodos(
    String title,
    String description,
    DateTime dateTime,
  ) async {
    try {
      if (currentUser != null) {
        final userId = currentUser!.uid;
        final todos = Todos(
            title: title,
            description: description,
            dateTime: dateTime,
            id: userId);
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('todos')
            .doc();

        await docRef.set(todos.toMap());

        // Refresh the todos list
        fetchTodos();
      }
    } catch (error) {
      print(error);
    }
  }

  void editTodos(String todosId, String title, String description) async {
    try {
      if (currentUser != null) {
        final userId = currentUser!.uid;
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('todos')
            .doc(todosId);

        await docRef.update({
          'title': title,
          'description': description,
        });

        // Refresh the todos list
        fetchTodos();
      }
    } catch (error) {
      print(error);
    }
  }

  void deleteTodos(String todosId) async {
    try {
      if (currentUser != null) {
        final userId = currentUser!.uid;
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('todos')
            .doc(todosId);

        await docRef.delete();

        // Refresh the todos list
        fetchTodos();
      }
    } catch (error) {
      print(error);
    }
  }
}

class Todos {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;

  Todos({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  Todos.fromSnapshot(DocumentSnapshot snapshot, DateTime dateTime)
      : id = snapshot.id,
        title = snapshot['title'],
        description = snapshot['description'],
        dateTime = snapshot['dateTime'].toDate();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }
}
