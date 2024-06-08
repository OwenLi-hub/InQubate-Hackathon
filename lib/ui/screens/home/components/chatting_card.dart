import 'package:flutter/material.dart';

import '../../../../constants.dart';

class ChattingCardData {
  final ImageProvider image;
  final bool isOnline;
  final String name;
  final String lastMessage;
  final bool isRead;
  final int totalUnread;

  const ChattingCardData({
    required this.image,
    required this.isOnline,
    required this.name,
    required this.lastMessage,
    required this.isRead,
    required this.totalUnread,
  });
}

class ChattingCard extends StatelessWidget {
  const ChattingCard({required this.data, required this.onPressed, super.key});

  final ChattingCardData data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: kSpacing),
          leading: Stack(
            children: [
              CircleAvatar(backgroundImage: data.image),
              CircleAvatar(
                backgroundColor: data.isOnline ? Colors.green : Colors.grey,
                radius: 5,
              ),
            ],
          ),
          title: Text(
            data.name,
            style: const TextStyle(
              fontSize: 13,
              color: kPrimaryColor,
            ),
          ),
          subtitle: Text(
            data.lastMessage,
            style: const TextStyle(
              fontSize: 11,
              color: kPrimaryColor,
            ),
          ),
          onTap: onPressed,
          trailing: (!data.isRead && data.totalUnread > 1)
              ? _notif(data.totalUnread)
              : Icon(
            Icons.check,
            color: data.isRead ? Colors.grey : Colors.green,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _notif(int total) {
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        (total >= 100) ? "99+" : "$total",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}