import 'package:eduglobe_app/constants.dart';
import 'package:flutter/material.dart';

import '../../../../util/helpers/task_type.dart';


class OverviewHeader extends StatelessWidget {
  const OverviewHeader({
    required this.onSelected,
    this.axis = Axis.horizontal,
    super.key,
  });

  final Function(TaskType? task) onSelected;
  final Axis axis;
  @override
  Widget build(BuildContext context) {
    TaskType task = TaskType.todo;

    return (axis == Axis.horizontal)
          ? Row(
        children: [
          const Text(
            "Task Overview",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          ..._listButton(
            task: task,
            onSelected: (value) {
              task = value;
              onSelected(value);
            },
          )
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Task Overview",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _listButton(
                task: task,
                onSelected: (value) {
                  task = value;
                  onSelected(value);
                },
              ),
            ),
          ),
        ],
      );
  }

  List<Widget> _listButton({
    required TaskType task,
    required Function(TaskType value) onSelected,
  }) {
    return [
      _button(
        selected: task == TaskType.todo,
        label: "All",
        onPressed: () {
          task = TaskType.todo;
          onSelected(TaskType.todo);
        },
      ),
      _button(
        selected: task == TaskType.todo,
        label: "To do",
        onPressed: () {
          task = TaskType.todo;
          onSelected(TaskType.todo);
        },
      ),
      _button(
        selected: task == TaskType.inProgress,
        label: "In progress",
        onPressed: () {
          task = TaskType.inProgress;
          onSelected(TaskType.inProgress);
        },
      ),
      _button(
        selected: task == TaskType.done,
        label: "Done",
        onPressed: () {
          task = TaskType.done;
          onSelected(TaskType.done);
        },
      ),
    ];
  }

  Widget _button({
    required bool selected,
    required String label,
    required Function() onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: 140,
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: selected ? kPrimaryColor : kPrimaryColor, backgroundColor: selected
              ? Colors.grey
              : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}