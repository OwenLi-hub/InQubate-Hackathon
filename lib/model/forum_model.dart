import 'package:eduglobe_app/model/reply_model.dart';

import 'author_model.dart';

class Topic{
  String title;
  String description;
  int likes;
  int repliesCount;
  int views;
  String createdAt;
  Author author;
  String? id;

  Topic({
    required this.title,
    required this.description,
    required this.likes,
    required this.repliesCount,
    required this.views,
    required this.createdAt,
    required this.author,
    required this.id
  });
}

