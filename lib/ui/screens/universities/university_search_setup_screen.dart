import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class UniversitySearchSetupScreen extends StatefulWidget {
  const UniversitySearchSetupScreen({super.key});

  @override
  State<UniversitySearchSetupScreen> createState() => _UniversitySearchSetupScreenState();
}

class _UniversitySearchSetupScreenState extends State<UniversitySearchSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedCountry = '';
  String _selectedProgram = '';

  final List<String> _countries = ['Canada', 'USA', 'UK', 'Australia'];
  final List<String> _programs = ['Engineering', 'Business', 'Arts', 'Sciences'];

  bool _isLoading = true;
  late String _initialCountry;
  late String _initialProgram;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? user = _auth.currentUser;
    try {
      DocumentSnapshot userDoc = await _firestore.collection('profiles').doc(user?.uid).get();
      setState(() {
        _initialCountry = userDoc['countriesOfInterest'];
        _initialProgram = userDoc['studyPreferences'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error fetching user profile: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButtonFormField<String>(
              value: _initialCountry,
              hint: const Text('Select Country'),
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value!;
                });
              },
              items: _countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              validator: (value) => value == null ? 'Please select a country' : null,
            ),
            DropdownButtonFormField<String>(
              value: _initialProgram,
              hint: const Text('Select Program'),
              onChanged: (value) {
                setState(() {
                  _selectedProgram = value!;
                });
              },
              items: _programs.map((String program) {
                return DropdownMenuItem<String>(
                  value: program,
                  child: Text(program),
                );
              }).toList(),
              validator: (value) => value == null ? 'Please select a program' : null,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Search Universities'),
            ),
          ],
        ),
      ),
    );
  }
}
