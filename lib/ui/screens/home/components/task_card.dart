import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../util/helpers/task_type.dart';
import 'list_profile_image.dart';

class TaskCardData {
  final String title;
  final int dueDay;
  final List<ImageProvider> profileContributors;
  final TaskType type;
  final int totalComments;
  final int totalContributors;

  const TaskCardData({
    required this.title,
    required this.dueDay,
    required this.totalComments,
    required this.totalContributors,
    required this.type,
    required this.profileContributors,
  });
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.data,
    required this.onPressedMore,
    required this.onPressedTask,
    required this.onPressedContributors,
    required this.onPressedComments,
    required this.otherUse,
    required this.subtitle,
    this.width,
    super.key,
  });

  final TaskCardData data;

  final Function() onPressedMore;
  final Function() onPressedTask;
  final Function() onPressedContributors;
  final Function() onPressedComments;
  final bool otherUse;
  final String subtitle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TaskTile(
                dotColor: data.type.getColor(),
                showDelete: otherUse,
                title: data.title,
                subtitle: otherUse ? subtitle :
                (data.dueDay < 0)
                    ? "Late in ${data.dueDay * -1} days"
                    : "Due in ${(data.dueDay > 1) ? "${data.dueDay} days" : "today"}",
                onPressedMore: onPressedMore,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 140,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0, backgroundColor: data.type.getColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: onPressedTask,
                      child: Text(
                        data.type.toStringValue(),
                      ),
                    ),
                  ),
                  ListProfileImage(
                    images: data.profileContributors,
                    onPressed: onPressedContributors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpacing / 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing / 2),
              child: Row(
                children: [
                  _IconButton(
                    iconData: EvaIcons.messageCircleOutline,
                    onPressed: onPressedComments,
                    totalContributors: data.totalComments,
                  ),
                  const SizedBox(width: kSpacing / 2),
                  _IconButton(
                    iconData: EvaIcons.peopleOutline,
                    onPressed: onPressedContributors,
                    totalContributors: data.totalContributors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpacing / 2),
          ],
        ),
      ),
    );
  }
}

/* -----------------------------> COMPONENTS <------------------------------ */
class TaskTile extends StatelessWidget {
  const TaskTile({super.key,
    required this.dotColor,
    required this.title,
    required this.subtitle,
    required this.onPressedMore,
    required this.showDelete
  });

  final Color dotColor;
  final String title;
  final String subtitle;
  final Function() onPressedMore;
  final bool showDelete;

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
              taskDot(dotColor),
              const SizedBox(width: 8),
              Expanded(child: taskTitle(title)),
              _moreButton(onPressed: onPressedMore, showDelete: showDelete),
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

  Widget taskDot(Color color) {
    return CircleAvatar(
      radius: 4,
      backgroundColor: color,
    );
  }

  Widget taskTitle(String data) {
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

  Widget _moreButton({required Function() onPressed, required bool showDelete}) {
    return IconButton(
      iconSize: 20,
      onPressed: onPressed,
      icon: showDelete ? const Icon(Icons.delete) : const Icon(Icons.more_vert_rounded),
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