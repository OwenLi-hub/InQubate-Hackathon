import 'dart:developer';

import 'package:eduglobe_app/ui/screens/community/forum_detail_screen.dart';
import 'package:flutter/material.dart';

import '../../../../model/forum_model.dart';

class ForumTile extends StatefulWidget {
  const ForumTile({required this.forum, super.key});

  final Topic forum;

  @override
  State<ForumTile> createState() => _ForumTileState();
}

class _ForumTileState extends State<ForumTile> {

  bool showForum = false;

  @override
  Widget build(BuildContext context) {
    return showForum ? ForumDetailScreen(forum: widget.forum) :
      Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              showForum = true;
            });
          },
          child: Container(
            height: 180,
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26.withOpacity(0.05),
                      offset: const Offset(0.0, 6.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.10)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              AssetImage(widget.forum.author.imageUrl),
                          radius: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  widget.forum.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .4),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.forum.author.name,
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.6)),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    widget.forum.createdAt,
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.6)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.grey.withOpacity(0.6),
                          size: 26,
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: Text(
                      widget.forum.description,
                      style: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontSize: 16,
                          letterSpacing: .3),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up_outlined,
                            color: Colors.grey.withOpacity(0.6),
                            size: 22,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "${widget.forum.likes} likes",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.6),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.email_outlined,
                            color: Colors.grey.withOpacity(0.6),
                            size: 16,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "${widget.forum.repliesCount} replies",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.6)),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.grey.withOpacity(0.6),
                            size: 18,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "${widget.forum.views} views",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.6)),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
