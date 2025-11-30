import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class PhoneInputCard extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback onSendOtp;
  final bool isLoading;

  const PhoneInputCard({
    super.key,
    required this.controller,
    required this.errorText,
    required this.onSendOtp,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.call, color: theme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  s.phone_number,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            TextFormField(
              key: const Key('phoneField'),
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: s.phone_number_hint,
                errorText: errorText,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                key: const Key('sendOtpButton'),
                onPressed: isLoading ? null : onSendOtp,
                child: isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: theme.scaffoldBackgroundColor,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        "${s.send} ${s.otp}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
