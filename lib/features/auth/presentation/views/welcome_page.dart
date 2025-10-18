import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/leaf_painter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    const logo = 'assets/images/green_connect_logo.png';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            /// ===== Drop leaves animation =====
            const FallingLeaves(),

            /// ===== Main content =====
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ===== Logo =====
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeIn,
                        child: Image.asset(
                          logo,
                          width: 260,
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // ===== Text hello =====
                  AnimatedSlide(
                    offset: const Offset(0, 0.1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    child: Column(
                      children: [
                        Text(
                          S.of(context)!.hello_first,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.of(context)!.hello_second,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 42),

                  // ===== Buttons =====
                  GradientButton(
                    text: S.of(context)!.login,
                    onPressed: () {
                      context.go('/login');
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go('/register'),
                      child: Text(S.of(context)!.register),
                    ),
                  ),

                  const SizedBox(height: 42),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
