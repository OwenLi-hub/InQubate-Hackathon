import 'dart:developer';
import 'package:eduglobe_app/ui/screens/home/components/selection_button.dart';
import 'package:eduglobe_app/ui/screens/home/components/university_card.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '../../../../constants.dart';
import '../../../components/upgrade_premium_card.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    required this.data,
    super.key,
  });

  final UniversityCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: SizedBox(
                child: UniversityCard(
                  data: data,
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
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: kSpacing * 2),
            UpgradePremiumCard(
              backgroundColor: Theme.of(context).canvasColor.withOpacity(.4),
              onPressed: () {},
            ),
            const SizedBox(height: kSpacing),
          ],
        ),
      ),
    );
  }
}