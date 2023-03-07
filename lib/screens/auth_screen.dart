// ignore_for_file: avoid_print

import 'package:chat_app/widgets/Auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String userName,
    String email,
    String password,
    AuthMode isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCred;

    try {
      if (isLogin == AuthMode.login) {
        userCred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
    } on FirebaseAuthException catch (err) {
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
      // print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm), // we passing it here as a pointer of fn
    );
  }
}
