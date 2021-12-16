import 'package:auth/authentication.dart';
import 'package:auth/component/required_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pretty_json/pretty_json.dart';

class SimpleSignInScreen extends StatefulWidget {
  const SimpleSignInScreen({Key? key}) : super(key: key);

  @override
  State<SimpleSignInScreen> createState() => _SimpleSignInScreenState();
}

class _SimpleSignInScreenState extends State<SimpleSignInScreen> {
  String _result = "";
  String _error = "";
  bool _isLoading = false;
  final form = GlobalKey<FormState>();

  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  void _signInDidTap() {
    FocusScope.of(context).unfocus();
    if (form.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = "";
        _result = "";
      });

      Authentication authentication = Authentication(client: Client());
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
                _error = error is UsernameOrPasswordError
                    ? "Username or password is not correct."
                    : "Oops, Something went wrong. Please try again.";
              }));
    }
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
              buildSignInForm(),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: _isLoading
                    ? buildLoadingIndicator()
                    : _error.isNotEmpty
                        ? buildErrorMessage()
                        : buildResult(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSignInForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Form(
              key: form,
              child: Column(
                children: [
                  RequiredTextField(
                    inputLabel: "Username",
                    controller: usernameTextEditingController,
                  ),
                  RequiredTextField(
                    inputLabel: "Password",
                    controller: passwordTextEditingController,
                    isSecure: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _signInDidTap,
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }

  Scrollbar buildResult() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Text(_result),
        ),
      ),
      isAlwaysShown: true,
    );
  }

  Text buildErrorMessage() {
    return Text(
      _error,
      style: const TextStyle(color: Colors.red),
    );
  }

  Center buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
