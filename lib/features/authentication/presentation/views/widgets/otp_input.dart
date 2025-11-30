import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInputCard extends StatelessWidget {
  final TextEditingController controller;
  final String phoneNumber;
  final Function(String) onCompleted;
  final Function() onResend;
  final String? errorText;
  final bool isLoading;

  final bool isCounting;
  final int secondsRemaining;

  const OtpInputCard({
    super.key,
    required this.controller,
    required this.phoneNumber,
    required this.onCompleted,
    required this.onResend,
    this.errorText,
    required this.isLoading,
    required this.isCounting,
    required this.secondsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: theme.textTheme.titleLarge,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger),
      ),
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              s.verification,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(s.enter_the_code, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              phoneNumber,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            /// --- Pinput OTP ---
            Pinput(
              key: const Key('otpField'),
              length: 6,
              controller: controller,
              enabled: !isLoading,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              errorPinTheme: errorPinTheme,
              autofocus: true,
              keyboardType: TextInputType.number,
              onCompleted: onCompleted,
            ),

            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errorText!,
                  style: const TextStyle(color: AppColors.danger),
                ),
              ),

            const SizedBox(height: 24),

            /// --- RESEND with COUNTDOWN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(s.didnt_get_code, style: theme.textTheme.bodyMedium),
                isCounting
                    ? Text(
                        " (${secondsRemaining}s)",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : TextButton(
                        onPressed: isLoading ? null : onResend,
                        child: Text(s.resend),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
