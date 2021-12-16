import 'package:auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:pretty_json/pretty_json.dart';

class UserPasswordScreen extends StatefulWidget {
  const UserPasswordScreen({Key? key}) : super(key: key);

  @override
  State<UserPasswordScreen> createState() => _UserPasswordScreenState();
}

class _UserPasswordScreenState extends State<UserPasswordScreen> {
  String _result = "";
  bool _isLoading = false;

  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  void _signInDidTap() {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    Authentication authentication = Authentication();
    authentication
        .signIn(
          username: usernameTextEditingController.text,
          password: passwordTextEditingController.text,
        )
        .then((claim) => setState(() {
              _isLoading = false;
              _result = prettyJson(claim, indent: 2);
            }))
        .catchError((error) => setState(() {
              _isLoading = false;
              _result = "Username or password is not correct.";
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Username Password"),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white12,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                            controller: usernameTextEditingController,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            controller: passwordTextEditingController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _signInDidTap,
                      child: Text('Sign in'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Scrollbar(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Text(_result),
                          ),
                        ),
                        isAlwaysShown: true,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Row(
// children: [
// Column(
// children: <Widget>[

// ],
// ),
// const SizedBox(
// width: 8,
// ),
// ElevatedButton(
// onPressed: _signInDidTap,
// child: const Text('Sign in'),
// ),
// ],
// ),
