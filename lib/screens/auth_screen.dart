// ignore_for_file: avoid_print

import 'package:chat_app/widgets/Auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuthForm(
    String userName,
    String email,
    String password,
    AuthMode isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCred;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin == AuthMode.login) {
        userCred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
          'username': userName,
          'email': email,
          'password': password,
        });
      }
    } on FirebaseAuthException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var msg = 'an error occured please check your credentials';
      if (err.message != null) {
        msg = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
          _submitAuthForm, _isLoading), // we passing it here as a pointer of fn
    );
  }
}
