import 'package:flutter/material.dart';


class AppTaskCard extends StatefulWidget {
  const AppTaskCard({required this.onTap, required this.task, super.key});

  final Map<String, dynamic> task;
  final VoidCallback? onTap;

  @override
  State<AppTaskCard> createState() => _AppTaskCardState();
}

class _AppTaskCardState extends State<AppTaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 300,
        child: ListTile(
          title: Text(widget.task['title']),
          onTap: widget.onTap,
          trailing: (widget.task['isEssay'] ?? false)
              ? const Icon(Icons.article_outlined)
              : widget.task['completed']
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.circle, color: Colors.grey),
        ),
      ),
    );
  }
}
