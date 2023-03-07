import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitAuthForm, {super.key});

  final void Function(
    String userName,
    String email,
    String password,
    AuthMode isLogin,
    BuildContext ctx,
  ) submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum AuthMode { signup, login }

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.login;

  String _email = '';
  String _username = '';
  String _password = '';

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitAuthForm(
        _username.trim(),
        _email.trim(),
        _password.trim(),
        _authMode,
        context,
      );
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    // to identify each value for each field
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'please enter a valid email.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (newValue) {
                      _email = newValue!;
                    },
                  ),
                  if (_authMode == AuthMode.login)
                    TextFormField(
                      key: const ValueKey('Usernamee'),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return 'please enter at least 4 character';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (newValue) {
                        _username = newValue!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('Password'),
                    validator: (value) {
                      if (value == null || value.length < 7) {
                        return 'please enter at least 7 character';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (newValue) {
                      _password = newValue!;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.login ? 'Signup' : 'Login'),
                  ),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(_authMode == AuthMode.login
                        ? 'I already have an account'
                        : 'Create new account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
