import 'dart:async';

import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/core/helper/validate_std.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/providers/auth_provider.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/widgets/otp_input.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/widgets/phone_input.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? _phoneApiError;
  String? _otpApiError;

  int seconds = 30;
  bool isCounting = false;
  Timer? timer;

  void startCountdown() {
    timer?.cancel();
    setState(() {
      seconds = 30;
      isCounting = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
        setState(() => isCounting = false);
      } else {
        setState(() => seconds--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    ref.invalidate(authViewModelProvider);
    super.dispose();
  }

  void _handleBackNavigation() {
    phoneController.clear();
    otpController.clear();
    setState(() {
      _phoneApiError = null;
      _otpApiError = null;
    });
    ref.invalidate(authViewModelProvider);
    context.go('/');
  }

  void _clearLoginState() {
    phoneController.clear();
    otpController.clear();
    timer?.cancel();
    setState(() {
      _phoneApiError = null;
      _otpApiError = null;
      seconds = 30;
      isCounting = false;
    });
    ref.invalidate(authViewModelProvider);
  }

  Future<void> _sendOtp() async {
    setState(() {
      _phoneApiError = null;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phone = phoneController.text.trim();
    final formatted = validateAndFormatToE164(phone, isoCode: IsoCode.VN);

    if (formatted == null) {
      setState(() => _phoneApiError = S.of(context)!.invalid_phone_number);
      return;
    }
    await ref.read(authViewModelProvider.notifier).sendOtp(formatted);
    if (!mounted) return;
    // ------------------------------------------

    final state = ref.read(authViewModelProvider);

    if (state.errorMessage != null) {
      final error = state.errorMessage!.toLowerCase();

      if (error.contains("invalid-phone")) {
        setState(() => _phoneApiError = S.of(context)!.invalid_phone_number);
      } else if (error.contains("too-many-requests")) {
        CustomToast.show(
          context,
          S.of(context)!.too_many_request_error,
          type: ToastType.error,
        );
      } else if (error.contains("network") ||
          error.contains("network-request-failed")) {
        CustomToast.show(
          context,
          S.of(context)!.network_error_message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          context,
          S.of(context)!.unknown_error,
          type: ToastType.error,
        );
      }
      return;
    }
    if (state.verificationId != null) {
      CustomToast.show(
        context,
        "${S.of(context)!.send} ${S.of(context)!.otp} $formatted",
        type: ToastType.success,
      );
      startCountdown();
    }
  }

  bool _handleLoginError(dynamic state) {
    if (state.errorMessage == null && state.errorCode == null) return false;

    if (state.errorCode == 403) {
      CustomToast.show(context, state.errorMessage!, type: ToastType.error);
    } else {
      CustomToast.show(
        context,
        state.errorMessage ?? S.of(context)!.login_error,
        type: ToastType.error,
      );
    }
    return true;
  }

  void _navigateByRoles(dynamic loginState) {
    final userRoles = loginState.userRoles ?? [];

    final isCollector =
        Role.hasRole(userRoles, Role.businessCollector) ||
        Role.hasRole(userRoles, Role.individualCollector);

    if (isCollector) {
      GoRouter.of(context).go('/collector-home');
      return;
    }
    final isHousehold = Role.hasRole(userRoles, Role.household);
    if (isHousehold) {
      bool needSetup = loginState.fullName?.trim().isEmpty ?? true;
      GoRouter.of(context).go(needSetup ? '/setup-profile' : '/household-home');
      return;
    }

    GoRouter.of(context).go('/setup-profile');
  }

  Future<void> _verifyAndLogin() async {
    appLoading.value = true;
    setState(() => _otpApiError = null);

    try {
      if (!_formKey.currentState!.validate()) return;

      final otp = otpController.text.trim();
      await ref.read(authViewModelProvider.notifier).verifyOtp(smsCode: otp);
      if (!mounted) return;

      final otpState = ref.read(authViewModelProvider);

      if (otpState.errorMessage != null) {
        final err = otpState.errorMessage!;
        if (err.contains('invalid-verification-code') ||
            err.contains('code mismatch')) {
          setState(() => _otpApiError = S.of(context)!.invalid_otp_message);
        } else {
          CustomToast.show(context, err, type: ToastType.error);
        }
        return;
      }

      final idToken = await otpState.userCredential?.user?.getIdToken();
      if (idToken == null) return;

      await ref.read(authViewModelProvider.notifier).loginSystem(idToken);
      if (!mounted) return;

      final loginState = ref.read(authViewModelProvider);
      if (_handleLoginError(loginState)) return;

      // Clear all login state after successful login
      _clearLoginState();

      _navigateByRoles(loginState);
    } finally {
      appLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final size = MediaQuery.of(context).size;

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;
    final isOtpSent = authState.verificationId != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.cardColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(spacing.screenPadding),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme.iconTheme.color,
              size: 20,
            ),
            onPressed: _handleBackNavigation,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withValues(alpha: 0.05),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.screenPadding,
              vertical: spacing.screenPadding / 2,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.02),

                    // Hero Illustration
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey(isOtpSent),
                        width: size.width * 0.35,
                        height: size.width * 0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.primaryColor.withValues(alpha: 0.2),
                              theme.primaryColor.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            isOtpSent
                                ? Icons.verified_user_rounded
                                : Icons.phone_android_rounded,
                            size: size.width * 0.18,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Welcome Text with Animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            isOtpSent
                                ? S.of(context)!.verification
                                : S.of(context)!.welcome_login_primary,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isOtpSent
                                ? S.of(context)!.enter_the_code
                                : 'Đăng nhập để tiếp tục sử dụng ứng dụng',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.04),

                    // Animated Card Switcher
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: isOtpSent
                          ? OtpInputCard(
                              key: const ValueKey('otp'),
                              controller: otpController,
                              phoneNumber: phoneController.text.trim(),
                              errorText: _otpApiError,
                              isLoading: isLoading,
                              isCounting: isCounting,
                              secondsRemaining: seconds,
                              onCompleted: (value) => _verifyAndLogin(),
                              onResend: () => _sendOtp(),
                            )
                          : PhoneInputCard(
                              key: const ValueKey('phone'),
                              controller: phoneController,
                              errorText: _phoneApiError,
                              isLoading: isLoading,
                              onSendOtp: _sendOtp,
                            ),
                    ),

                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
