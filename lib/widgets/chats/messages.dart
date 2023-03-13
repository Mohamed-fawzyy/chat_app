import 'package:chat_app/widgets/chats/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// we make her the future builder is the parent of stream builder to avoid
// redudant data updating from stream [thats mean for each change in msgs
// streambuilder.build makes full rebuild so we dont need to rebuild catching
// the user id by firebase auth ]

// Here, we're using the Future.sync constructor to create a new Future object
// that resolves to the User object. Since we're sure that the User object isnot
// null, we can use the non-null version of the User type.

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
        future: Future.sync(() => currUser),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createAtTime', descending: true)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final chatDocs = chatSnapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) => MessageBubble(
                  msg: chatDocs[index]['text'],
                  isMe: chatDocs[index]['userId'] == futureSnapshot.data!.uid,
                  key: ValueKey(chatDocs[index].id),
                ),
              );
            },
          );
        });
  }
}
