import 'package:flutter/material.dart';

class RequiredTextField extends StatelessWidget {
  const RequiredTextField({
    Key? key,
    required this.inputLabel,
    required this.controller,
    this.isSecure = false,
  }) : super(key: key);

  final String inputLabel;
  final TextEditingController controller;
  final bool isSecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: inputLabel,
      ),
      controller: controller,
      obscureText: isSecure,
      autocorrect: false,
      validator: errorMessageFor(inputLabel.toLowerCase()),
    );
  }
}

String? Function(String?) errorMessageFor(String inputLabel) {
  return (value) {
    if (value == null || value.isEmpty) {
      return "Please enter your $inputLabel";
    }
    return null;
  };
}
