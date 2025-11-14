import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isOtpSent = false;
  bool isLoading = false;

  /// Giả lập gửi OTP
  Future<void> _sendOtp() async {
    print("Sending OTP...");
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.phone_number_hint)));
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Giả lập call API

    setState(() {
      isLoading = false;
      isOtpSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${S.of(context)!.otp} sent to $phone')),
    );
  }

  /// Giả lập login với OTP
  void _login() {
    final otp = otpController.text.trim();
    final phone = phoneController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.otp_hint)));
      return;
    }

    if (phone == '0987654321' && otp == '123456') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Welcome back!')));
      context.push('/household-home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid phone number or OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => context.go('/'),
        ),
        title: Text(S.of(context)!.back, style: theme.textTheme.titleLarge),
        shape: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),

              /// ====== Tiêu đề ======
              Text(
                S.of(context)!.welcome_login_primary,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                S.of(context)!.welcome_login_secondary,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              /// ====== Card chứa form ======
              Card(
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.dividerColor),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(spacing.screenPadding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Phone field =====
                      Row(
                        children: [
                          Icon(Icons.call, color: theme.primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            S.of(context)!.phone_number,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: !isOtpSent, // Disable khi đã gửi OTP
                        decoration: InputDecoration(
                          hintText: S.of(context)!.phone_number_hint,
                          filled: true,
                          fillColor: theme.inputDecorationTheme.fillColor,
                          contentPadding:
                              theme.inputDecorationTheme.contentPadding,
                          border: theme.inputDecorationTheme.border,
                          enabledBorder:
                              theme.inputDecorationTheme.enabledBorder,
                          focusedBorder:
                              theme.inputDecorationTheme.focusedBorder,
                          hintStyle: theme.inputDecorationTheme.hintStyle,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (!isOtpSent)
                        SizedBox(
                          key: const Key('sendOtpButton'),
                          width: double.infinity,
                          height: 50,
                          child: GradientButton(
                            text:
                                "${S.of(context)!.send} ${S.of(context)!.otp}",
                            onPressed: () => isLoading ? null : _sendOtp(),
                          ),
                        ),

                      if (isOtpSent) ...[
                        // ===== OTP field =====
                        Row(
                          children: [
                            Icon(
                              Icons.sms,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${S.of(context)!.send} ${S.of(context)!.otp}",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: S.of(context)!.otp_hint,
                            filled: true,
                            fillColor: theme.inputDecorationTheme.fillColor,
                            contentPadding:
                                theme.inputDecorationTheme.contentPadding,
                            border: theme.inputDecorationTheme.border,
                            enabledBorder:
                                theme.inputDecorationTheme.enabledBorder,
                            focusedBorder:
                                theme.inputDecorationTheme.focusedBorder,
                            hintStyle: theme.inputDecorationTheme.hintStyle,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          key: const Key('loginButton'),
                          width: double.infinity,
                          height: 50,
                          child: GradientButton(
                            text: S.of(context)!.login,
                            onPressed: () => isLoading ? null : _login(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// ====== Register link ======
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context)!.dont_have_account,
                    style: theme.textTheme.bodyLarge,
                  ),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: Text(
                      " ${S.of(context)!.register_here}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
