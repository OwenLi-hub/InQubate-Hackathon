import 'package:eduglobe_app/ui/screens/home/components/task_card.dart';
import 'package:eduglobe_app/ui/screens/universities/university_search_setup_screen.dart';
import 'package:eduglobe_app/util/helpers/task_type.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';
import '../home/components/list_profile_image.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  List _savedUniversities = [];
  bool showUniversitySetupScreen = false;

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

  void _startNewSearch() {
    setState(() {
      showUniversitySetupScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : showUniversitySetupScreen
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const UniversitySearchSetupScreen(),
                )
              : _savedUniversities.isEmpty
                  ? Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: _startNewSearch,
                          child: const Text('Start New Search'),
                        ),
                      ),
                    )
                  : Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        width: 200,
                        child: ElevatedButton(
                          onPressed: _startNewSearch,
                          child: const Text('Start New Search'),
                        ),
                      ),
                      GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // number of items in each row
                            mainAxisSpacing: 8.0, // spacing between rows
                            crossAxisSpacing: 8.0, // spacing between columns
                          ),
                          itemCount: _savedUniversities.length,
                          addAutomaticKeepAlives: false,
                          padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var university = _savedUniversities[index];
                            return SizedBox(
                              height: 50,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(kBorderRadius),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: UniversityTile(
                                        dotColor: TaskType.done.getColor(),
                                        title: university['university'],
                                        subtitle: university['program'],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kSpacing),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            height: 30,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    TaskType.done.getColor(),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                "Tuition: ${university['tuition_fees']}",
                                              ),
                                            ),
                                          ),
                                          ListProfileImage(
                                            images: const [
                                              AssetImage("assets/images/logo.png"),
                                            ],
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing / 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kSpacing / 2),
                                      child: SizedBox(
                                        height: 20,
                                        child: Row(
                                          children: [
                                            _IconButton(
                                              iconData: EvaIcons.messageCircleOutline,
                                              onPressed: () {},
                                              totalContributors: 50,
                                            ),
                                            const SizedBox(width: kSpacing / 2),
                                            _IconButton(
                                              iconData: EvaIcons.peopleOutline,
                                              onPressed: () {},
                                              totalContributors: 60,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing / 2),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Website: ${university['website']}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Grade Average: ${university['requirements']['grade_average']}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'IB Points: ${university['requirements']['ib_points']}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'IELTS Points: ${university['requirements']['ielts_points']}'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
    );
  }
}

/* -----------------------------> COMPONENTS <------------------------------ */
class UniversityTile extends StatelessWidget {
  const UniversityTile({
    super.key,
    required this.dotColor,
    required this.title,
    required this.subtitle,
  });

  final Color dotColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _dot(dotColor),
              const SizedBox(width: 8),
              Expanded(child: _title(title)),
              _moreButton(onPressed: () {}),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _subtitle(subtitle),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _dot(Color color) {
    return CircleAvatar(
      radius: 4,
      backgroundColor: color,
    );
  }

  Widget _title(String data) {
    return Text(
      data,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _subtitle(String data) {
    return Text(
      data,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _moreButton({required Function() onPressed}) {
    return IconButton(
      iconSize: 20,
      onPressed: onPressed,
      icon: const Icon(Icons.more_vert_rounded),
      splashRadius: 20,
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.iconData,
    required this.totalContributors,
    required this.onPressed,
  });

  final IconData iconData;
  final int totalContributors;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 25,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
        onPressed: onPressed,
        icon: _icon(iconData),
        label: _label("$totalContributors"),
      ),
    );
  }

  Widget _label(String data) {
    return Text(
      data,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 10,
      ),
    );
  }

  Widget _icon(IconData iconData) {
    return Icon(
      iconData,
      color: Colors.white54,
      size: 14,
    );
  }
}
