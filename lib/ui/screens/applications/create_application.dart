import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../util/service/application_service.dart';


class CreateApplication extends StatefulWidget {
  const CreateApplication({required this.onSave, super.key});

  final VoidCallback onSave;

  @override
  State<CreateApplication> createState() => _CreateApplicationState();
}

class _CreateApplicationState extends State<CreateApplication> {
  List _savedUniversities = [];
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  bool _isApplicationSaved = false;


  String? selectedUniversity;
  String? selectedProgram;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();


  @override
  void initState() {
    super.initState();
    _fetchActiveUniversities();
  }

  Future<void> _fetchActiveUniversities() async {
    User? user = _auth.currentUser;
    try {
      final userUniversities = await _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('selectedUniversities')
          .get();

      setState(() {
        _savedUniversities =
            userUniversities.docs.map((doc) => doc.data()).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error fetching universities: $e');
    }
  }

  List<Map<String, dynamic>> _generateTasks() {
    return [
      {'title': 'Create account on university portal', 'completed': false},
      {'title': 'Fill application form', 'completed': false},
      {'title': 'Get recommendation letters', 'completed': false},
      {'title': 'Upload transcripts', 'completed': false},
      {'title': 'Write your SOP', 'completed': false, 'isEssay': true},
      {'title': 'Submit application', 'completed': false},
      {'title': 'Pay application fee', 'completed': false},
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<String> universities = _savedUniversities.map((map) => map['university'] as String).toSet().toList();
    List<String> programs = _savedUniversities.map((map) => map['program'] as String).toSet().toList();

    // If the selectedUniversity is not in the unique names list, reset it to null
    if (selectedUniversity != null && !universities.contains(selectedUniversity)) {
      selectedUniversity = null;
    }

    if (selectedProgram != null && !programs.contains(selectedProgram)) {
      selectedProgram = null;
    }

    return _isApplicationSaved ? Center(
      child: Text(
        "Congrats! Your application to $selectedUniversity for $selectedProgram has been created!"
      ),
    ):
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 280,
              child: DropdownButtonFormField<String>(
                value: selectedUniversity,
                items: universities.map((university) {
                  return DropdownMenuItem(
                    value: university,
                    child: Text(university),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUniversity = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select University'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a university';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: 280,
              child: DropdownButtonFormField<String>(
                value: selectedProgram,
                items: programs.map((program) {
                  return DropdownMenuItem(
                    value: program,
                    child: Text(program),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProgram = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Program'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a program';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _firestoreService.createApplication({
                      'university': selectedUniversity,
                      'program': selectedProgram,
                      'tasks': _generateTasks(),
                    });
                    widget.onSave();
                    setState(() {
                      _isApplicationSaved = true;
                    });
                  }
                },
                child: const Text('Create Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
