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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
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

              // Card section
              Card(
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.dividerColor),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.call, color: theme.primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            S.of(context)!.phone_number,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
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
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: GradientButton(
                          text: "${S.of(context)!.send} ${S.of(context)!.otp}",
                          onPressed: () {
                            // Handle send OTP action
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context)!.dont_have_account,
                    style: theme.textTheme.bodyMedium,
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
