// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/5IvZQ2rCfglvyRBhYr55/messages')
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = streamSnapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: ((context, index) => Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(docs[index]['text']),
                )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/5IvZQ2rCfglvyRBhYr55/messages')
              .add({'text': 'this is added by clicking!'});
        },
      ),
    );
  }
}
