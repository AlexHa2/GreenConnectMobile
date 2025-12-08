import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Payment WebView Page
/// 
/// This page will display the VNPay payment URL in a WebView.
/// After payment completion, VNPay will redirect to the backend,
/// which will then redirect to: greenconnect://payment-result?status=success|failed
/// 
/// TODO: Install webview_flutter package or flutter_inappwebview package
/// Run: flutter pub add webview_flutter
/// or: flutter pub add flutter_inappwebview
class PaymentWebViewPage extends StatelessWidget {
  final String paymentUrl;
  final String? transactionRef;
  final String? packageName;

  const PaymentWebViewPage({
    super.key,
    required this.paymentUrl,
    this.transactionRef,
    this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(packageName ?? s.payment_method_title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: s.close,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(space * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.payment,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: space * 2),
              Text(
                s.confirm_payment,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: space),
              Text(
                'Transaction: ${transactionRef ?? 'N/A'}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: space * 3),
              Container(
                padding: EdgeInsets.all(space * 1.5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(space),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    SizedBox(height: space),
                    Text(
                      'WebView Integration Required',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: space * 0.5),
                    Text(
                      'To complete payment integration:\n'
                      '1. Add webview_flutter package\n'
                      '2. Implement WebView widget\n'
                      '3. Handle deep link redirects',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: space * 2),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Copy URL to clipboard or open in external browser
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Payment URL: $paymentUrl'),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: s.close,
                        onPressed: () {},
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.link),
                label: const Text('Show Payment URL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
