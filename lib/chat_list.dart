import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_message.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  final chatStream = FirebaseFirestore.instance
      .collection('chat')
      .orderBy('time', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('$snapshot.error'));
        } else if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        final messages =
        ChatMessage.fromQueryDocumentSnapshot(snapshot.data!.docs);

        return ListView.builder(
          itemCount: messages.length,
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemBuilder: (context, index) {
            return ListTile(
              leading: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.indigo),
                child: Text(messages[index].timestamp),
              ),
              title: Text(messages[index].message),
            );
          },
        );
      },
    );
  }
}
