import 'dart:developer';

import 'package:eduglobe_app/ui/screens/applications/application_detail.dart';
import 'package:eduglobe_app/ui/screens/applications/create_application.dart';
import 'package:eduglobe_app/util/helpers/task_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../constants.dart';
import '../../../util/service/application_service.dart';
import '../home/components/overview_header.dart';
import '../home/components/task_card.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> applications = [];
  bool isLoading = true;
  bool showApplicationSetup = false;
  bool showApplicationDetail = false;

  String clickedAppId = '';
  String clickedUni = '';

  // Define a Set to keep track of which items should show ApplicationDetail
  Set<int> itemsToShowDetail = Set<int>();

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    applications = await _firestoreService.fetchApplications();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
              children: [
                showApplicationSetup
                    ? CreateApplication(onSave: fetchApplications)
                    : Center(
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showApplicationSetup = true;
                              });
                            },
                            child: const Text('Start New Application'),
                          ),
                        ),
                      ),
                showApplicationSetup
                    ? const SizedBox()
                    : StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: applications.length,
                        addAutomaticKeepAlives: false,
                        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var application = applications[index];
                          print(applications);

                          // If shouldShowDetail is true, show the ApplicationDetail widget
                          if (showApplicationDetail && itemsToShowDetail.contains(index)) {
                            return Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: 800,
                                child: ApplicationDetail(
                                  applicationId: clickedAppId,
                                  university: clickedUni
                                ),
                              ),
                            );
                          }

                          // Check if the index is 0 (for "Your Applications" Text widget) or not in itemsToShowDetail
                          // if (index == 0 || !shouldShowDetail) {
                          return !showApplicationDetail ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      itemsToShowDetail
                                          .clear(); // Clear all other items
                                      itemsToShowDetail
                                          .add(index); // Add the clicked item
                                      clickedAppId = application['id'];
                                      clickedUni = application['university'];
                                      showApplicationDetail = true;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                    child: TaskCard(
                                      data: TaskCardData(
                                        title: application['university'],
                                        dueDay: 3,
                                        totalComments: 4,
                                        totalContributors: 10,
                                        type: TaskType.inProgress,
                                        profileContributors: [
                                          const AssetImage(
                                              "assets/images/logo.png"),
                                        ],
                                      ),
                                      onPressedMore: () async {
                                        await _firestoreService
                                            .deleteApplication(application['id']);
                                        fetchApplications();
                                      },
                                      onPressedTask: () {},
                                      onPressedContributors: () {},
                                      onPressedComments: () {},
                                      otherUse: true,
                                      subtitle: application['program'],
                                    ),
                                  ),
                                ) : const SizedBox();
                          // }
                        },
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit((2)),
                      ),
              ],
            ),
        );
  }
}
