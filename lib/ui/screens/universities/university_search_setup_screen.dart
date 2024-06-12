import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduglobe_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UniversitySearchSetupScreen extends StatefulWidget {
  const UniversitySearchSetupScreen({super.key});

  @override
  State<UniversitySearchSetupScreen> createState() =>
      _UniversitySearchSetupScreenState();
}

class _UniversitySearchSetupScreenState
    extends State<UniversitySearchSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedCountry = '';
  String _selectedProgram = '';
  String _selectedBackground = '';
  String _selectedLanguage = '';
  String _selectedBudget = '';

  final List<String> _countries = ['Canada', 'USA', 'UK', 'Australia'];
  final List<String> _programs = ["Engineering", "Computer Science", "Business", "Medicine", "Law", "Nursing", "Pharmacy", "Agriculture", "Environmental Science", "Arts", "Mathematics"];
  final List<String> _academicBackgrounds = [
    'High School',
    'Undergraduate',
    'Graduate',
    'PhD'
  ];
  final List<String> _languageProficiencies = [
    'English',
    'French',
    'Spanish',
    'German'
  ];
  final List<String> _budgetRanges = [
    '< \$10,000',
    '\$10,000 - \$20,000',
    '\$20,000 - \$30,000',
    '> \$30,000'
  ];

  bool _isLoading = true;
  late String _initialCountry;
  late String _initialProgram;
  late String _initialBackground;
  late String _initialLanguage;
  late String _initialBudget;

  List<dynamic> universityList = [];

  List<dynamic> selectedUniversities = [];
  List<dynamic> savedUniversities = [];
  bool isSaving = false;

  final userId =
      FirebaseAuth.instance.currentUser?.uid; // Get the current user ID

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    fetchSavedUniversities();
  }

  Future<void> fetchSavedUniversities() async {
    final userUniversities = await _firestore
        .collection('users')
        .doc(userId)
        .collection('selectedUniversities')
        .get();

    setState(() {
      savedUniversities =
          userUniversities.docs.map((doc) => doc.data()).toList();
      _isLoading = false;
    });
  }

  Future<void> _fetchUserProfile() async {
    User? user = _auth.currentUser;
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('profiles').doc(user?.uid).get();
      setState(() {
        _initialCountry = userDoc['countriesOfInterest'];
        _initialProgram = userDoc['studyPreferences'];
        _initialBackground = userDoc['academicBackground'];
        _initialLanguage = userDoc['languageProficiency'];
        _initialBudget = userDoc['budgetRange'];
        _selectedCountry = _initialCountry;
        _selectedProgram = _initialProgram;
        _selectedBackground = _initialBackground;
        _selectedLanguage = _initialLanguage;
        _selectedBudget = _initialBudget;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _selectedCountry = _countries[0];
        _selectedProgram = _programs[0];
        _selectedBackground = _academicBackgrounds[0];
        _selectedLanguage = _languageProficiencies[0];
        _selectedBudget = _budgetRanges[0];
      });
      Fluttertoast.showToast(msg: 'Error fetching user profile: $e');
    }
  }

  void _searchUniversities() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call Flask API to get university recommendations
      await fetchUniversityRecommendations(
        country: _selectedCountry,
        program: _selectedProgram,
        language: _selectedLanguage,
        background: _selectedBackground,
        budget: _selectedBudget
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchUniversityRecommendations(
      {required String country,
      required String program,
      required String language,
      required String budget,
      required String background}) async {


    final response = await http.post(
      Uri.parse('$webAPIUrl/recommend_universities'),
      headers: {"Access-Control-Allow-Origin": "*", 'Content-Type': 'application/json', 'Accept': '*/*' },
      body: json.encode({'study_level': background, 'program': program, 'budget': budget, 'conversation_id': "1"}), //todo: conversation_id
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      var botResponse = data['response'];
      setState(() {
        universityList = botResponse;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load recommendations');
    }
  }

  void toggleUniversitySelection(dynamic university) {
    setState(() {
      if (selectedUniversities.contains(university)) {
        selectedUniversities.remove(university);
      } else {
        selectedUniversities.add(university);
      }
    });
  }

  Future<void> saveSelectedUniversities() async {
    setState(() {
      isSaving = true;
    });

    for (var university in selectedUniversities) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('selectedUniversities')
          .add(university);
    }

    fetchSavedUniversities();
    setState(() {
      isSaving = false;
      selectedUniversities.clear();
    });

    // Optionally, show a success message or navigate back
    Fluttertoast.showToast(msg: 'Universities saved successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<String>(
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
                          validator: (value) =>
                              value == null ? 'Please select a country' : null,
                        ),
                      ),
                      SizedBox(
                        width: 230,
                        child: DropdownButtonFormField<String>(
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
                          validator: (value) =>
                              value == null ? 'Please select a program' : null,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: _searchUniversities,
                          child: const Text('Search Universities'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 550,
                  child: Column(
                    children: [
                      if (universityList.isNotEmpty) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                          alignment: Alignment.centerLeft,
                          child: const Text('Recommended Universities',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        StaggeredGridView.countBuilder(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          addAutomaticKeepAlives: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: universityList.length,
                          itemBuilder: (context, index) {
                            var university = universityList[index];
                            return Card(
                              child: InkWell(
                                onTap: () => toggleUniversitySelection(university),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(university['university'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold, color: kPrimaryColor)),
                                      const SizedBox(height: 4),
                                      Text('Program: ${university['program']}'),
                                      Text('Province: ${university['province']}'),
                                      Text(
                                          'Tuition Fees: ${university['tuition_fees']}'),
                                      Text('Website: ${university['website']}'),
                                      Text(
                                          'Grade Average: ${university['requirements']['grade_average']}'),
                                      Text(
                                          'IB Points: ${university['requirements']['ib_points']}'),
                                      Text(
                                          'IELTS Points: ${university['requirements']['ielts_points']}'),
                                      Checkbox(
                                        value:
                                        selectedUniversities.contains(university),
                                        onChanged: (bool? value) {
                                          toggleUniversitySelection(university);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(1),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: selectedUniversities.isNotEmpty && !isSaving
                                ? saveSelectedUniversities
                                : null,
                            child: isSaving
                                ? const CircularProgressIndicator()
                                : const Text('Save Selections'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  height: 600,
                  child: Column(
                    children: [
                      if (savedUniversities.isNotEmpty) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                          alignment: Alignment.centerLeft,
                          child: const Text('Previously Saved Universities',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: savedUniversities.length,
                            itemBuilder: (context, index) {
                              var university = savedUniversities[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(university['university'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold, color: kPrimaryColor)),
                                      const SizedBox(height: 4),
                                      Text('Program: ${university['program']}'),
                                      Text('Province: ${university['province']}'),
                                      Text(
                                          'Tuition Fees: ${university['tuition_fees']}'),
                                      Text('Website: ${university['website']}'),
                                      Text(
                                          'Grade Average: ${university['requirements']['grade_average']}'),
                                      Text(
                                          'IB Points: ${university['requirements']['ib_points']}'),
                                      Text(
                                          'IELTS Points: ${university['requirements']['ielts_points']}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                            staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
