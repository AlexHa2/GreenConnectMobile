import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/leaf_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      const AssetImage("assets/images/green_connect_logo.png"),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    const logo = 'assets/images/green_connect_logo.png';
    
    // Tính toán responsive sizes
    final logoSize = (screenHeight * 0.25).clamp(180.0, 260.0);
    final fontSize = (screenHeight * 0.05).clamp(28.0, 42.0);
    final spacingBetween = (screenHeight * 0.05).clamp(24.0, 42.0);
    final spacingBottom = (screenHeight * 0.05).clamp(24.0, 42.0);
    
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;
                  final needsScroll = availableHeight < screenHeight * 0.8;
                  
                  final content = Column(
                    mainAxisAlignment: needsScroll 
                        ? MainAxisAlignment.start 
                        : MainAxisAlignment.center,
                    mainAxisSize: needsScroll 
                        ? MainAxisSize.min 
                        : MainAxisSize.max,
                    children: [
                      // ===== Logo =====
                      if (!needsScroll)
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: 1,
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeIn,
                              child: Image.asset(
                                logo,
                                width: logoSize,
                                height: logoSize,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(height: spacingBetween * 0.5),
                      
                      if (!needsScroll) const SizedBox.shrink()
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: spacingBetween),
                          child: AnimatedOpacity(
                            opacity: 1,
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeIn,
                            child: Image.asset(
                              logo,
                              width: logoSize,
                              height: logoSize,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                      // ===== Text hello =====
                      AnimatedSlide(
                        offset: const Offset(0, 0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                S.of(context)!.hello_first,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.of(context)!.hello_second,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.primaryColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: spacingBetween),

                      // ===== Buttons =====
                      GradientButton(
                        key: const Key('goLogin'),
                        text: S.of(context)!.login,
                        onPressed: () {
                          context.go('/login');
                        },
                      ),

                      // const SizedBox(height: 10),
                      // SizedBox(
                      //   key: const Key('goRegister'),
                      //   width: double.infinity,
                      //   child: OutlinedButton(
                      //     style: OutlinedButton.styleFrom(
                      //       side: BorderSide(color: theme.primaryColor),
                      //     ),
                      //     onPressed: () => context.go('/register'),
                      //     child: Text(S.of(context)!.register),
                      //   ),
                      // ),
                      SizedBox(height: spacingBottom),
                    ],
                  );
                  
                  if (needsScroll) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: content,
                        ),
                      ),
                    );
                  } else {
                    return content;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
