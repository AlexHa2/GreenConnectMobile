import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Payment WebView Page
///
/// This page displays the VNPay payment URL in a WebView.
/// After payment completion, VNPay will redirect to the backend,
/// which will then redirect to: greenconnect://payment-result?status=success|failed
class PaymentWebViewPage extends StatefulWidget {
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
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  var _loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              _loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _loadingPercentage = 100;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('greenconnect://')) {
              debugPrint('[PAYMENT CALLBACK] URL: ${request.url}');
              final uri = Uri.parse(request.url);
              final responseCode = uri.queryParameters['vnp_ResponseCode'];
              final transactionStatus = uri.queryParameters['vnp_TransactionStatus'];
              final isSuccess = responseCode == '00' && transactionStatus == '00';
              final extraData = {
                'amount': uri.queryParameters['vnp_Amount'],
                'bank': uri.queryParameters['vnp_BankCode'],
                'orderInfo': uri.queryParameters['vnp_OrderInfo'],
                'payDate': uri.queryParameters['vnp_PayDate'],
                'transactionNo': uri.queryParameters['vnp_TransactionNo'],
                'txnRef': uri.queryParameters['vnp_TxnRef'],
                'cardType': uri.queryParameters['vnp_CardType'],
                'responseCode': responseCode,
                'transactionStatus': transactionStatus,
                'bankTranNo': uri.queryParameters['vnp_BankTranNo'],
                'tmnCode': uri.queryParameters['vnp_TmnCode'],
                'secureHash': uri.queryParameters['vnp_SecureHash'],
              };
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (isSuccess) {
                  context.go('/payment-success', extra: extraData);
                } else {
                  context.go('/payment-failed', extra: extraData);
                }
              });
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.packageName ?? s.payment_method_title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: s.close,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loadingPercentage < 100)
            LinearProgressIndicator(
              value: _loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
