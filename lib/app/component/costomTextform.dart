import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String? Function(String?)? validator;
  final String? label;
  final String hint;
  final TextEditingController? controller;
  const CustomTextForm({
    super.key,
    this.label,
    this.validator,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          hintText: hint,
          labelText: label,
        ),
      ),
    );
  }
}
