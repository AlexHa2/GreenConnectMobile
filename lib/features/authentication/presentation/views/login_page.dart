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
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: _handleBackNavigation,
        ),
        title: Text(S.of(context)!.back, style: theme.textTheme.titleLarge),
        shape: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                const SizedBox(height: 40),

                if (isOtpSent)
                  OtpInputCard(
                    controller: otpController,
                    phoneNumber: phoneController.text.trim(),
                    errorText: _otpApiError,
                    isLoading: isLoading,
                    isCounting: isCounting,
                    secondsRemaining: seconds,
                    onCompleted: (value) => _verifyAndLogin(),
                    onResend: () => _sendOtp(),
                  )
                else
                  PhoneInputCard(
                    controller: phoneController,
                    errorText: _phoneApiError,
                    isLoading: isLoading,
                    onSendOtp: _sendOtp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
