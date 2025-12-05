import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
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
    final spacing = theme.extension<AppSpacing>()!; //12
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone Number Label with Icon
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.screenPadding / 1.5,
                vertical: spacing.screenPadding / 2.5,
              ),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_android_rounded,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.phone_number,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: spacing.screenPadding),

            // Phone Input Field
            TextFormField(
              key: const Key('phoneField'),
              controller: controller,
              keyboardType: TextInputType.phone,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: s.phone_number_hint,
                errorText: errorText,
                prefixIcon: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: spacing.screenPadding / 1.5,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.screenPadding / 1.5,
                    vertical: spacing.screenPadding / 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.country_flag,
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: spacing.screenPadding / 3),
                      Text(
                        s.country_code,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.primaryColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: spacing.screenPadding,
                  vertical: spacing.screenPadding * 0.9,
                ),
              ),
            ),

            SizedBox(height: spacing.screenPadding * 1.2),

            // Send OTP Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                key: const Key('sendOtpButton'),
                onPressed: isLoading ? null : onSendOtp,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                  disabledBackgroundColor: theme.primaryColor.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: theme.scaffoldBackgroundColor,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded, size: 20),
                          SizedBox(width: spacing.screenPadding / 2.5),
                          Text(
                            "${s.send} ${s.otp}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(height: spacing.screenPadding * 0.8),

            // Security Info
            Container(
              padding: EdgeInsets.all(spacing.screenPadding / 1.5),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 18,
                    color: theme.primaryColor.withValues(alpha: 0.7),
                  ),
                  SizedBox(width: spacing.screenPadding / 2.5),
                  Expanded(
                    child: Text(
                      s.otp_security_message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.8,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
