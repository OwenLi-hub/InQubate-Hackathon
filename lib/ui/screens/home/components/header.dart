import 'package:eduglobe_app/ui/screens/home/components/search_field.dart';
import 'package:eduglobe_app/ui/screens/home/components/today_text.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TodayText(),
        const SizedBox(width: kSpacing),
        Expanded(child: SearchField()),
      ],
    );
  }
}