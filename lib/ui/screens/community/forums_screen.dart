import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduglobe_app/ui/screens/community/components/categories.dart';
import 'package:eduglobe_app/ui/screens/community/components/forum_tile.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../model/author_model.dart';
import '../../../model/forum_model.dart';

class CommunityForumsScreen extends StatefulWidget {
  const CommunityForumsScreen({super.key});

  @override
  State<CommunityForumsScreen> createState() => _CommunityForumsScreenState();
}

class _CommunityForumsScreenState extends State<CommunityForumsScreen> {
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Best Study Practices',
      'description': 'Share and learn best study practices.',
      'createdAt': '2 hours ago',
      'likes': 234,
      'repliesCount': 59,
      'views': 444
    },
    {
      'title': 'Studying in Canada',
      'description': 'Advice and experiences studying in Canada.',
      'createdAt': '7 hours ago',
      'likes': 24,
      'repliesCount': 43,
      'views': 333
    },
    {
      'title': 'Visa Application Tips',
      'description': 'Tips for applying for a visa.',
      'createdAt': '13 hours ago',
      'likes': 34,
      'repliesCount': 77,
      'views': 123
    },
    {
      'title': 'Finding Housing',
      'description': 'Tips for finding student housing.',
      'createdAt': '22 hours ago',
      'likes': 134,
      'repliesCount': 12,
      'views': 222
    },
    {
      'title': 'Available Scholarships',
      'description': 'Information on current scholarships.',
      'createdAt': '12 hours ago',
      'likes': 14,
      'repliesCount': 44,
      'views': 58
    },
  ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Topics",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16.0),
          const ForumCategories(),
          const SizedBox(height: 36.0),
          const Text(
            "Trending Forums",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          StreamBuilder(
            stream: _firestore.collection('forums').doc("sjZflWvt8GzBlQPtuv2y").collection("topics").snapshots(), //todo: this is for a topic not a forum!!!!!
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var topics = snapshot.data?.docs;
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemCount: topics?.length,
                  itemBuilder: (context, index) {
                    var topic = topics?[index];
                    return ForumTile(
                      forum: Topic(
                        author: Author(
                          name: 'EduGlobe',
                          imageUrl: 'assets/images/logo.png',
                        ),
                        title: topic?['title'],
                        description: topic?['description'],
                        likes: topic?['likes'],
                        repliesCount: 1,
                        views: topic?['views'],
                        createdAt: timeago.format(topic?['createdAt'].toDate()),
                        id: topic?.id  //todo: this is for a topic not a forum
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
