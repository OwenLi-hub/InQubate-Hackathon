import 'package:flutter/material.dart';
import '../../../../constants.dart';

class ProgressCardData {
  final int totalUndone;
  final int totalTaskInProgress;

  const ProgressCardData({
    required this.totalUndone,
    required this.totalTaskInProgress,
  });
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.data,
    required this.onPressedCheck,
    super.key,
  });

  final ProgressCardData data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(10, 30),
                child: SizedBox(
                  width: 200,
                  child: Image.asset(
                    "assets/icons/signup.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: kSpacing,
              top: kSpacing,
            ),
            margin: const EdgeInsets.symmetric(vertical: kSpacing, horizontal: kSpacing),
            height: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You Have ${data.totalUndone} recent Tasks",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "${data.totalTaskInProgress} Tasks are in progress",
                  style: const TextStyle(color: kPrimaryColor),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: onPressedCheck,
                  child: const Text("Check"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}