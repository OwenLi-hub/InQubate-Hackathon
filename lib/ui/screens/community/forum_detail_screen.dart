import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduglobe_app/constants.dart';
import 'package:eduglobe_app/model/forum_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../model/author_model.dart';
import '../../../model/reply_model.dart';


class ForumDetailScreen extends StatefulWidget {

  const ForumDetailScreen({required this.forum, super.key});

  final Topic forum;

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {

  List<Reply> replies = [
    Reply(
        author: Author(
          name: 'EduGlobe',
          imageUrl: 'assets/images/logo.png',
        ),
        content: 'This is a very useful tip!',
        likes: 120
    ),
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [BoxShadow(
                    color: Colors.black26.withOpacity(0.05),
                    offset: const Offset(0.0,6.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.10
                )]
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(widget.forum.author.imageUrl),
                              radius: 22,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      widget.forum.author.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .4
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    widget.forum.createdAt,
                                    style: const TextStyle(
                                        color: Colors.grey
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.grey.withOpacity(0.6),
                          size: 26,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      widget.forum.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.forum.description,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 16,
                        letterSpacing: .2
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_up_outlined,
                              color: Colors.grey.withOpacity(0.5),
                              size: 22,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "${widget.forum.likes} likes",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 15.0),
                        Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.grey.withOpacity(0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "${widget.forum.views} views",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.5),
                                fontWeight: FontWeight.w600,

                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),
            child: Container(
              alignment: Alignment.centerLeft,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(kBorderRadius),
              //   border: Border.all(color: kPrimaryColor)
              // ),
              child: Text(
                "Replies (${replies.length})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream:  _firestore
                .collection('forums')
                .doc("sjZflWvt8GzBlQPtuv2y")
                .collection('topics')
                .doc(widget.forum.id)
                .collection('comments')
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var comments = snapshot.data?.docs;
              return Column(
                children: comments!.map((comment) =>
                    Container(
                        margin: const EdgeInsets.only(left:50.0, right: 15.0, top: 20.0, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: kPrimaryColor),
                          boxShadow: [BoxShadow(
                              color: Colors.black26.withOpacity(0.03),
                              offset: const Offset(0.0,6.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.10
                          )],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 60,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundImage: AssetImage("assets/images/logo.png"),
                                          radius: 18,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                comment['user']['name'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: .4
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(
                                                widget.forum.createdAt,
                                                style: TextStyle(
                                                    color: Colors.grey.withOpacity(0.4)
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: Text(
                                  comment['content'],
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.25),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.thumb_up_outlined,
                                    color: Colors.grey.withOpacity(0.5),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    "${comment['likes']}",
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Add a comment',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (value) async {
                                    User? user = FirebaseAuth.instance.currentUser;
                                    await _firestore
                                        .collection('forums')
                                        .doc("sjZflWvt8GzBlQPtuv2y")
                                        .collection('topics')
                                        .doc(widget.forum.id)
                                        .collection('comments')
                                        .add({
                                      'user': {
                                        'name': "James Doe",
                                        'id': user?.uid
                                      },
                                      'content': value,
                                      'likes': 1,
                                      'timestamp': FieldValue.serverTimestamp(),
                                    });
                                    commentController.clear;
                                    value = "";
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                ).toList(),
              );
            }
          )
        ],
      );
  }
}

