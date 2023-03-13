import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enterdMsg = '';
  final _controller = TextEditingController();

  void _sendMsg() {
    _enterdMsg = '';
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enterdMsg,
      'createAtTime': Timestamp.now(),
      'userId': user!.uid,
    });
    _enterdMsg = '';
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 10),
      padding: const EdgeInsets.only(
        bottom: 20,
        right: 10,
        left: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Send a message...',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 0.3),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _enterdMsg = value;
                });
              },
              onSubmitted: (value) {
                _enterdMsg = '';
              },
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: _enterdMsg.trim().isEmpty ? null : _sendMsg,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
