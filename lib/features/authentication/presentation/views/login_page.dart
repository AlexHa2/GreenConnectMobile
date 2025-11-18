import 'package:GreenConnectMobile/core/helper/validate_std.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/providers/auth_provider.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/viewmodels/states/auth_state.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();

  //   ref.listen<AuthState>(authViewModelProvider, (previous, next) {
  //     setState(() {
  //       isLoading = next.isLoading;
  //     });

  //     if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
  //     }
  //   });
  // }

  Future<void> _sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.phone_number_hint)));
      return;
    }
    final formatted = validateAndFormatToE164(phone, isoCode: IsoCode.VN);
    if (formatted == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.invalid_phone_number)),
      );
      return;
    }

    await ref.read(authViewModelProvider.notifier).sendOtp(formatted);

    final state = ref.read(authViewModelProvider);
    if (state.verificationId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context)!.otp} sent to $formatted')),
      );
    }
  }

  Future<void> _verifyAndLogin() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.otp_hint)));
      return;
    }

    await ref.read(authViewModelProvider.notifier).verifyOtp(smsCode: otp);
    final state = ref.read(authViewModelProvider);

    if (state.userCredential != null) {
      final idToken = await state.userCredential!.user?.getIdToken();
      if (idToken != null) {
        await ref.read(authViewModelProvider.notifier).loginSystem(idToken);

        final loginState = ref.read(authViewModelProvider);
        if (loginState.errorMessage == null) {
          context.push('/household-home');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final size = MediaQuery.of(context).size;

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;
    final isOtpSent = authState.verificationId != null;

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
                      // Phone field
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
                        enabled: !isOtpSent,
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

                      // OTP / login buttons
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
                        Row(
                          children: [
                            Icon(
                              Icons.sms,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              S.of(context)!.otp,
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
                            onPressed: () =>
                                isLoading ? null : _verifyAndLogin(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
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
