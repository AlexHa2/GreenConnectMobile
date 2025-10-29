import 'package:flutter/material.dart';

class LableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? validatorMsg;
  const LableField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.validatorMsg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          validator: validatorMsg != null
              ? (value) =>
                    value == null || value.trim().isEmpty ? validatorMsg : null
              : null,
        ),
      ],
    );
  }
}
