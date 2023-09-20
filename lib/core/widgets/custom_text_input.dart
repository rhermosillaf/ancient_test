import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;

  const CustomTextInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    required this.onChanged,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: obscureText,
      obscuringCharacter: "*",
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
