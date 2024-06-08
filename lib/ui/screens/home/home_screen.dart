import 'dart:developer';

import 'package:eduglobe_app/constants.dart';
import 'package:eduglobe_app/ui/screens/community/forums_screen.dart';
import 'package:eduglobe_app/ui/screens/home/components/university_card.dart';
import 'package:eduglobe_app/ui/screens/universities/universities_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../model/user_model.dart';
import '../../../util/helpers/task_type.dart';
import '../../components/get_premium_card.dart';
import '../../components/responsive_builder.dart';
import '../../components/upgrade_premium_card.dart';
import 'components/active_university_card.dart';
import 'components/chatting_card.dart';
import 'components/header.dart';
import 'components/overview_header.dart';
import 'components/profile_tile.dart';
import 'components/progress_card.dart';
import 'components/progress_report_card.dart';
import 'components/recent_messages.dart';
import 'components/selection_button.dart';
import 'components/sidebar.dart';
import 'components/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool showDashboardScreen = true;
  bool showUniScreen = false;
  bool showAppScreen = false;
  bool showVisaScreen = false;
  bool showCommScreen = false;
  bool showSettScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: Sidebar(
                  data: UniversityCardData(
                    percent: .3,
                    projectImage: const AssetImage("assets/images/logo.png"),
                    projectName: "EduGlobe",
                    releaseTime: DateTime.now(),
                  ),
                ),
              ),
            ),
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(onPressedMenu: () {
              if (scaffoldKey.currentState != null) {
                scaffoldKey.currentState!.openDrawer();
              }
            }),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(
                data: const Profile(
              photo: AssetImage("assets/images/logo.png"),
              name: "James Doe",
              email: "jamesdoe@gmail.com",
            )),
            const SizedBox(height: kSpacing),
            _buildProgress(axis: Axis.vertical),
            // const SizedBox(height: kSpacing),
            // _buildTeamMember(data: controller.getMember()),
            const SizedBox(height: kSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: GetPremiumCard(onPressed: () {}),
            ),
            const SizedBox(height: kSpacing * 2),
            _buildTaskOverview(
              data: [
                const TaskCardData(
                  title: "Get Letters of Recommendations",
                  dueDay: 2,
                  totalComments: 50,
                  type: TaskType.todo,
                  totalContributors: 30,
                  profileContributors: [
                    AssetImage("assets/images/logo.png"),
                  ],
                ),
                const TaskCardData(
                  title: "Fill out Application Form for Queen's University",
                  dueDay: -1,
                  totalComments: 50,
                  totalContributors: 34,
                  type: TaskType.inProgress,
                  profileContributors: [
                    AssetImage("assets/images/logo.png"),
                  ],
                ),
                const TaskCardData(
                  title: "Create Application Profile for Queen's University",
                  dueDay: 1,
                  totalComments: 50,
                  totalContributors: 34,
                  type: TaskType.done,
                  profileContributors: [
                    AssetImage("assets/images/logo.png"),
                  ],
                ),
              ],
              headerAxis: Axis.vertical,
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ),
            const SizedBox(height: kSpacing * 2),
            _buildActiveProject(
              data: [
                UniversityCardData(
                  percent: .3,
                  projectImage: const AssetImage("assets/images/logo.png"),
                  projectName: "Queen's University",
                  releaseTime: DateTime.now().add(const Duration(days: 130)),
                ),
                UniversityCardData(
                  percent: .5,
                  projectImage: const AssetImage("assets/images/logo.png"),
                  projectName: "Ryerson University",
                  releaseTime: DateTime.now().add(const Duration(days: 140)),
                ),
                UniversityCardData(
                  percent: .8,
                  projectImage: const AssetImage("assets/images/logo.png"),
                  projectName: "University of Toronto",
                  releaseTime: DateTime.now().add(const Duration(days: 100)),
                ),
              ],
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ),
            const SizedBox(height: kSpacing),
            _buildRecentMessages(data: [
              const ChattingCardData(
                image: AssetImage("assets/images/logo.png"),
                isOnline: true,
                name: "Queen's University Support",
                lastMessage: "i added my new tasks",
                isRead: false,
                totalUnread: 100,
              ),
              const ChattingCardData(
                image: AssetImage("assets/images/logo.png"),
                isOnline: false,
                name: "Visa Applications General Info",
                lastMessage: "well done john",
                isRead: true,
                totalUnread: 0,
              ),
              const ChattingCardData(
                image: AssetImage("assets/images/logo.png"),
                isOnline: true,
                name: "Getting Started in Canada",
                lastMessage: "we'll have a meeting at 9AM",
                isRead: false,
                totalUnread: 1,
              ),
            ]),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    _buildHeader(onPressedMenu: () {
                      if (scaffoldKey.currentState != null) {
                        scaffoldKey.currentState!.openDrawer();
                      }
                    }),
                    const SizedBox(height: kSpacing * 2),
                    _buildProgress(
                      axis: (constraints.maxWidth < 950)
                          ? Axis.vertical
                          : Axis.horizontal,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildTaskOverview(
                      data: [
                        const TaskCardData(
                          title: "Get Letters of Recommendations",
                          dueDay: 2,
                          totalComments: 50,
                          type: TaskType.todo,
                          totalContributors: 30,
                          profileContributors: [
                            AssetImage("assets/images/logo.png"),
                          ],
                        ),
                        const TaskCardData(
                          title:
                              "Fill out Application Form for Queen's University",
                          dueDay: -1,
                          totalComments: 50,
                          totalContributors: 34,
                          type: TaskType.inProgress,
                          profileContributors: [
                            AssetImage("assets/images/logo.png"),
                          ],
                        ),
                        const TaskCardData(
                          title:
                              "Create Application Profile for Queen's University",
                          dueDay: 1,
                          totalComments: 50,
                          totalContributors: 34,
                          type: TaskType.done,
                          profileContributors: [
                            AssetImage("assets/images/logo.png"),
                          ],
                        ),
                      ],
                      headerAxis: (constraints.maxWidth < 850)
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 950)
                          ? 6
                          : (constraints.maxWidth < 1100)
                              ? 3
                              : 2,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildActiveProject(
                      data: [
                        UniversityCardData(
                          percent: .3,
                          projectImage:
                              const AssetImage("assets/images/logo.png"),
                          projectName: "Queen's University",
                          releaseTime:
                              DateTime.now().add(const Duration(days: 130)),
                        ),
                        UniversityCardData(
                          percent: .5,
                          projectImage:
                              const AssetImage("assets/images/logo.png"),
                          projectName: "Ryerson University",
                          releaseTime:
                              DateTime.now().add(const Duration(days: 140)),
                        ),
                        UniversityCardData(
                          percent: .8,
                          projectImage:
                              const AssetImage("assets/images/logo.png"),
                          projectName: "University of Toronto",
                          releaseTime:
                              DateTime.now().add(const Duration(days: 100)),
                        ),
                      ],
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 950)
                          ? 6
                          : (constraints.maxWidth < 1100)
                              ? 3
                              : 2,
                    ),
                    const SizedBox(height: kSpacing),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 0.5 : 1.5)),
                    _buildProfile(
                        data: const Profile(
                      photo: AssetImage("assets/images/logo.png"),
                      name: "James Doe",
                      email: "jamesdoe@gmail.com",
                    )),
                    const Divider(thickness: 1),
                    // const SizedBox(height: kSpacing),
                    // _buildTeamMember(data: controller.getMember()),
                    const SizedBox(height: kSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: GetPremiumCard(onPressed: () {}),
                    ),
                    const SizedBox(height: kSpacing),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildRecentMessages(data: [
                      const ChattingCardData(
                        image: AssetImage("assets/images/logo.png"),
                        isOnline: true,
                        name: "Queen's University Support",
                        lastMessage: "i added my new tasks",
                        isRead: false,
                        totalUnread: 100,
                      ),
                      const ChattingCardData(
                        image: AssetImage("assets/images/logo.png"),
                        isOnline: false,
                        name: "Visa Applications General Info",
                        lastMessage: "well done john",
                        isRead: true,
                        totalUnread: 0,
                      ),
                      const ChattingCardData(
                        image: AssetImage("assets/images/logo.png"),
                        isOnline: true,
                        name: "Getting Started in Canada",
                        lastMessage: "we'll have a meeting at 9AM",
                        isRead: false,
                        totalUnread: 1,
                      ),
                    ]),
                  ],
                ),
              )
            ],
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 4 : 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(kBorderRadius),
                    bottomRight: Radius.circular(kBorderRadius),
                  ),
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(kSpacing),
                            child: SizedBox(
                              child: UniversityCard(
                                data: UniversityCardData(
                                  percent: .3,
                                  projectImage: const AssetImage(
                                      "assets/images/logo.png"),
                                  projectName: "EduGlobe",
                                  releaseTime: DateTime.now(),
                                ),
                              ),
                            ),
                          ),
                          const Divider(thickness: 1),
                          SelectionButton(
                            data: [
                              SelectionButtonData(
                                activeIcon: EvaIcons.grid,
                                icon: EvaIcons.gridOutline,
                                label: "Dashboard",
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.layers,
                                icon: EvaIcons.layersOutline,
                                label: "Universities",
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.calendar,
                                icon: EvaIcons.calendarOutline,
                                label: "Application",
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.briefcase,
                                icon: EvaIcons.briefcaseOutline,
                                label: "Visa",
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.people,
                                icon: EvaIcons.peopleOutline,
                                totalNotif: 20,
                                label: "Community",
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.settings,
                                icon: EvaIcons.settingsOutline,
                                label: "Settings",
                              ),
                            ],
                            onSelected: (index, value) {
                              log("index : $index | label : ${value.label}");
                              switch (value.label) {
                                case "Dashboard":
                                  setState(() {
                                    showVisaScreen = false;
                                    showUniScreen = false;
                                    showSettScreen = false;
                                    showCommScreen = false;
                                    showDashboardScreen = true;
                                    showAppScreen = false;
                                  });
                                case "Universities":
                                  setState(() {
                                    showVisaScreen = false;
                                    showUniScreen = true;
                                    showSettScreen = false;
                                    showCommScreen = false;
                                    showDashboardScreen = false;
                                    showAppScreen = false;
                                  });
                                case "Application":
                                  setState(() {
                                    showVisaScreen = false;
                                    showUniScreen = false;
                                    showSettScreen = false;
                                    showCommScreen = false;
                                    showDashboardScreen = false;
                                    showAppScreen = true;
                                  });
                                case "Visa":
                                  setState(() {
                                    showVisaScreen = true;
                                    showUniScreen = false;
                                    showSettScreen = false;
                                    showCommScreen = false;
                                    showDashboardScreen = false;
                                    showAppScreen = false;
                                  });
                                case "Community":
                                  setState(() {
                                    showVisaScreen = false;
                                    showUniScreen = false;
                                    showSettScreen = false;
                                    showCommScreen = true;
                                    showDashboardScreen = false;
                                    showAppScreen = false;
                                  });
                                case "Settings":
                                  setState(() {
                                    showVisaScreen = false;
                                    showUniScreen = false;
                                    showSettScreen = true;
                                    showCommScreen = false;
                                    showDashboardScreen = false;
                                    showAppScreen = false;
                                  });
                              }
                            },
                          ),
                          const Divider(thickness: 1),
                          const SizedBox(height: kSpacing * 2),
                          UpgradePremiumCard(
                            backgroundColor:
                                Theme.of(context).canvasColor.withOpacity(.4),
                            onPressed: () {},
                          ),
                          const SizedBox(height: kSpacing),
                        ],
                      ),
                    ),
                  ),
                  // Sidebar(
                  //   data: ,
                  // ),
                ),
              ),
              Flexible(
                flex: 9,
                child: showVisaScreen
                    ?
                    // VISA SCREEN
                    Column(
                        children: [
                          const SizedBox(height: kSpacing),
                          _buildHeader(),
                        ],
                      )
                    : showUniScreen
                        ?
                        // UNIVERSITIES SCREEN
                        Column(
                            children: [
                              const SizedBox(height: kSpacing),
                              _buildHeader(),
                              const SizedBox(height: kSpacing * 2),
                              const UniversitiesScreen()
                            ],
                          )
                        : showSettScreen
                            ?
                            // SETTINGS SCREEN
                            Column(
                                children: [
                                  const SizedBox(height: kSpacing),
                                  _buildHeader(),
                                ],
                              )
                            : showCommScreen
                                ?
                                // COMMUNITY SCREEN
                                Column(
                                    children: [
                                      const SizedBox(height: kSpacing),
                                      _buildHeader(),
                                      const SizedBox(height: kSpacing * 2),
                                      const CommunityForumsScreen()

                                    ],
                                  )
                                : showAppScreen
                                    ?
                                    // APPLICATIONS SCREEN
                                    Column(
                                        children: [
                                          const SizedBox(height: kSpacing),
                                          _buildHeader(),
                                        ],
                                      )
                                    :
                                    // DASHBOARD SCREEN
                                    Column(
                                        children: [
                                          const SizedBox(height: kSpacing),
                                          _buildHeader(),
                                          const SizedBox(height: kSpacing * 2),
                                          _buildProgress(),
                                          const SizedBox(height: kSpacing * 2),
                                          _buildTaskOverview(
                                            data: [
                                              const TaskCardData(
                                                title:
                                                    "Get Letters of Recommendations",
                                                dueDay: 2,
                                                totalComments: 50,
                                                type: TaskType.todo,
                                                totalContributors: 30,
                                                profileContributors: [
                                                  AssetImage(
                                                      "assets/images/logo.png"),
                                                ],
                                              ),
                                              const TaskCardData(
                                                title:
                                                    "Fill out Application Form for Queen's University",
                                                dueDay: -1,
                                                totalComments: 50,
                                                totalContributors: 34,
                                                type: TaskType.inProgress,
                                                profileContributors: [
                                                  AssetImage(
                                                      "assets/images/logo.png"),
                                                ],
                                              ),
                                              const TaskCardData(
                                                title:
                                                    "Create Application Profile for Queen's University",
                                                dueDay: 1,
                                                totalComments: 50,
                                                totalContributors: 34,
                                                type: TaskType.done,
                                                profileContributors: [
                                                  AssetImage(
                                                      "assets/images/logo.png"),
                                                ],
                                              ),
                                            ],
                                            crossAxisCount: 6,
                                            crossAxisCellCount:
                                                (constraints.maxWidth < 1360)
                                                    ? 3
                                                    : 2,
                                          ),
                                          const SizedBox(height: kSpacing * 2),
                                          _buildActiveProject(
                                            data: [
                                              UniversityCardData(
                                                percent: .3,
                                                projectImage: const AssetImage(
                                                    "assets/images/logo.png"),
                                                projectName:
                                                    "Queen's University",
                                                releaseTime: DateTime.now().add(
                                                    const Duration(days: 130)),
                                              ),
                                              UniversityCardData(
                                                percent: .5,
                                                projectImage: const AssetImage(
                                                    "assets/images/logo.png"),
                                                projectName:
                                                    "Ryerson University",
                                                releaseTime: DateTime.now().add(
                                                    const Duration(days: 140)),
                                              ),
                                              UniversityCardData(
                                                percent: .8,
                                                projectImage: const AssetImage(
                                                    "assets/images/logo.png"),
                                                projectName:
                                                    "University of Toronto",
                                                releaseTime: DateTime.now().add(
                                                    const Duration(days: 100)),
                                              ),
                                            ],
                                            crossAxisCount: 6,
                                            crossAxisCellCount:
                                                (constraints.maxWidth < 1360)
                                                    ? 3
                                                    : 2,
                                          ),
                                          const SizedBox(height: kSpacing),
                                        ],
                                      ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    _buildProfile(
                        data: const Profile(
                      photo: AssetImage("assets/images/logo.png"),
                      name: "James Doe",
                      email: "jamesdoe@gmail.com",
                    )),
                    const Divider(thickness: 1),
                    // const SizedBox(height: kSpacing),
                    // _buildTeamMember(data: controller.getMember()),
                    const SizedBox(height: kSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: GetPremiumCard(onPressed: () {}),
                    ),
                    const SizedBox(height: kSpacing),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildRecentMessages(data: [
                      const ChattingCardData(
                        image: AssetImage("assets/images/logo.png"),
                        isOnline: true,
                        name: "Queen's University Support",
                        lastMessage: "How is life on campus?",
                        isRead: false,
                        totalUnread: 100,
                      ),
                      const ChattingCardData(
                        image: AssetImage("assets/images/logo.png"),
                        isOnline: false,
                        name: "Visa Applications General Info",
                        lastMessage: "when is the best time to apply?",
                        isRead: true,
                        totalUnread: 0,
                      ),
                      const ChattingCardData(
                        image: AssetImage("assets/images/logo.png"),
                        isOnline: true,
                        name: "Getting Started in Canada",
                        lastMessage: "Canada gets really cold a lot",
                        isRead: false,
                        totalUnread: 1,
                      ),
                    ]),
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          const Expanded(child: Header()),
        ],
      ),
    );
  }

  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: const ProgressCardData(
                      totalUndone: 10,
                      totalTaskInProgress: 2,
                    ),
                    onPressedCheck: () {},
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                const Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "Overall Progress",
                      doneTask: 5,
                      percent: .3,
                      task: 3,
                      undoneTask: 10,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: const ProgressCardData(
                    totalUndone: 10,
                    totalTaskInProgress: 2,
                  ),
                  onPressedCheck: () {},
                ),
                const SizedBox(height: kSpacing / 2),
                const ProgressReportCard(
                  data: ProgressReportCardData(
                    title: "Overall Progress",
                    doneTask: 5,
                    percent: .3,
                    task: 3,
                    undoneTask: 10,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: OverviewHeader(
                  axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
                onPressedComments: () {},
              );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit((index == 0) ? crossAxisCount : crossAxisCellCount),
    );
  }

  Widget _buildActiveProject({
    required List<UniversityCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: ActiveUniversityCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return UniversityCard(data: data[index]);
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  }

  Widget _buildProfile({required Profile data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: ProfileTile(
        data: data,
        onPressedNotification: () {},
      ),
    );
  }

  // Widget _buildTeamMember({required List<ImageProvider> data}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: kSpacing),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _TeamMember(
  //           totalMember: data.length,
  //           onPressedAdd: () {},
  //         ),
  //         const SizedBox(height: kSpacing / 2),
  //         ListProfilImage(maxImages: 6, images: data),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data.map(
        (e) => ChattingCard(data: e, onPressed: () {}),
      ),
    ]);
  }
}
