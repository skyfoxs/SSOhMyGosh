import 'package:auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pretty_json/pretty_json.dart';

class SSOSignInScreen extends StatefulWidget {
  const SSOSignInScreen({Key? key}) : super(key: key);

  @override
  _SSOSignInScreenState createState() => _SSOSignInScreenState();
}

class _SSOSignInScreenState extends State<SSOSignInScreen> {
  String _result = "";
  String _error = "";
  bool _isLoading = false;

  _onPressedSignIn() {
    setState(() {
      _isLoading = true;
      _error = "";
      _result = "";
    });

    Authentication authentication = Authentication(client: Client());
    authentication
        .ssoSignIn()
        .then((claim) => setState(() {
              _isLoading = false;
              _result = prettyJson(claim, indent: 2);
            }))
        .catchError((error) => setState(() {
              _isLoading = false;
              _error = "Oops, Something went wrong. Please try again.";
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSO SignIn'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                onPressed: _onPressedSignIn,
                child: const Text('Continue with SSO'),
              ),
            ),
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
