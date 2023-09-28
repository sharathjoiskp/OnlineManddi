import 'package:flutter/material.dart';

class InformationField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const InformationField({
    required this.label,
    required this.placeholder,
    required this.controller,
    this.validator,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        validator: validator,
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  InfoRow({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}

Widget CommonProgressIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

void showCustomSnackBar(
    BuildContext context, String message, Color backgroundColor,
    {Duration duration = const Duration(seconds: 5)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}
