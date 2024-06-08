import 'package:eduglobe_app/constants.dart';
import 'package:flutter/material.dart';

class ForumCategories extends StatefulWidget {
  const ForumCategories({super.key});

  @override
  State<ForumCategories> createState() => _ForumCategoriesState();
}

class _ForumCategoriesState extends State<ForumCategories> {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Study Tips', 'description': 'Tips for effective studying.', 'postCount': 2},
    {'title': 'Visa Help', 'description': 'Help with visa applications.', 'postCount': 22},
    {'title': 'Accommodation', 'description': 'Finding and managing accommodation.', 'postCount': 12},
    {'title': 'Scholarships', 'description': 'Information on scholarships and funding.', 'postCount': 20},
  ];

  List<Color> colors  = [
    Colors.purple, Colors.blue, Colors.green, kPrimaryColor
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            margin: const EdgeInsets.only(left: 20.0),
            height: 110,
            width: 250,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  categories[index]['title']!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${categories[index]['postCount']!.toString()} posts',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: .7
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
