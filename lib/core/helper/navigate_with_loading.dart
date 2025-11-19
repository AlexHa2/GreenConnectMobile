import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appLoading = ValueNotifier<bool>(false);

Future<void> navigateWithLoading<T>(
  BuildContext context, {
  Future<void> Function()? asyncTask,
  required String route,
  T? extra, // extra kiểu generic
}) async {
  appLoading.value = true;

  try {
    if (asyncTask != null) {
      await asyncTask();
    }

    if (!context.mounted) return;

    GoRouter.of(context).go(route, extra: extra);
  } catch (e) {
    CustomToast.show(
      context,
      "${S.of(context)!.an_error_occurred_please_try_again}: $e",
      type: ToastType.error,
    );

    if (context.mounted) {
      appLoading.value = false;
    }
    rethrow;
  } finally {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        appLoading.value = false;
      }
    });
  }
}
