import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduglobe_app/ui/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../constants.dart';
import '../../login_screen.dart';
import '../already_have_an_account_check.dart';


class ProfileForm extends StatefulWidget {
  const ProfileForm({
    super.key,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {

  final _formKey = GlobalKey<FormState>();

  // Firebase Auth
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  // Sample data for dropdowns
  final List<String> _academicBackgrounds = ['High School', 'Undergraduate', 'Graduate', 'PhD'];
  final List<String> _studyPreferences = ['Engineering', 'Business', 'Arts', 'Sciences'];
  final List<String> _countriesOfInterest = ['Canada', 'USA', 'UK', 'Australia'];
  final List<String> _languageProficiencies = ['English', 'French', 'Spanish', 'German'];
  final List<String> _budgetRanges = ['< \$10,000', '\$10,000 - \$20,000', '\$20,000 - \$30,000', '> \$30,000'];

  // Selected values
  String _selectedAcademicBackground = 'High School';
  String _selectedStudyPreference = 'Engineering';
  String _selectedCountryOfInterest = 'Canada';
  String _selectedLanguageProficiency = 'English';
  String _selectedBudgetRange = '< \$10,000';

  // Defining Editing Controller
  final TextEditingController firstNameEditingController = TextEditingController();
  final TextEditingController lastNameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController confirmPasswordEditingController = TextEditingController();

  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;
      try {
        await _firestore.collection('profiles').doc(user?.uid).set({
          'academicBackground': _selectedAcademicBackground,
          'studyPreferences': _selectedStudyPreference,
          'countriesOfInterest': _selectedCountryOfInterest,
          'languageProficiency': _selectedLanguageProficiency,
          'budgetRange': _selectedBudgetRange,
          'user': {
            'email': user?.email
          }
        });

        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())); // Navigate to home screen after setup
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg:'Error saving profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator()) :
      Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedAcademicBackground,
            hint: const Text('Select Academic Background'),
            onChanged: (value) {
              setState(() {
                _selectedAcademicBackground = value!;
              });
            },
            items: _academicBackgrounds.map((String background) {
              return DropdownMenuItem<String>(
                value: background,
                child: Text(background),
              );
            }).toList(),
            validator: (value) => value == null ? 'Please select your academic background' : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: DropdownButtonFormField<String>(
              value: _selectedStudyPreference,
              hint: const Text('Select Study Preference'),
              onChanged: (value) {
                setState(() {
                  _selectedStudyPreference = value!;
                });
              },
              items: _studyPreferences.map((String preference) {
                return DropdownMenuItem<String>(
                  value: preference,
                  child: Text(preference),
                );
              }).toList(),
              validator: (value) => value == null ? 'Please select your study preference' : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child:  DropdownButtonFormField<String>(
              value: _selectedCountryOfInterest,
              hint: const Text('Select Country of Interest'),
              onChanged: (value) {
                setState(() {
                  _selectedCountryOfInterest = value!;
                });
              },
              items: _countriesOfInterest.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              validator: (value) => value == null ? 'Please select a country of interest' : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: DropdownButtonFormField<String>(
              value: _selectedLanguageProficiency,
              hint: const Text('Select Language Proficiency'),
              onChanged: (value) {
                setState(() {
                  _selectedLanguageProficiency = value!;
                });
              },
              items: _languageProficiencies.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              validator: (value) => value == null ? 'Please select your language proficiency' : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: DropdownButtonFormField<String>(
              value: _selectedBudgetRange,
              hint: const Text('Select Budget Range'),
              onChanged: (value) {
                setState(() {
                  _selectedBudgetRange = value!;
                });
              },
              items: _budgetRanges.map((String budget) {
                return DropdownMenuItem<String>(
                  value: budget,
                  child: Text(budget),
                );
              }).toList(),
              validator: (value) => value == null ? 'Please select your budget range' : null,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              _saveProfile(context);
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}