
import 'author_model.dart';

class Reply {
  Author author;
  String content;
  int likes;

  Reply({
    required this.author,
    required this.content,
    required this.likes
  });
}
