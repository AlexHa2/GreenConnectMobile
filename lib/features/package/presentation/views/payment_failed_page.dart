
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentFailedPage extends StatelessWidget {
  final Map<String, dynamic>? paymentInfo;
  const PaymentFailedPage({super.key, this.paymentInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    final space = spacing.screenPadding;

    String amount = paymentInfo?['amount'] ?? '';
    String bank = paymentInfo?['bank'] ?? '';
    String orderInfo = paymentInfo?['orderInfo'] ?? '';
    String payDate = paymentInfo?['payDate'] ?? '';
    String transactionNo = paymentInfo?['transactionNo'] ?? '';
    String txnRef = paymentInfo?['txnRef'] ?? '';
    String responseCode = paymentInfo?['responseCode'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(s.generic_error_message), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(space * 2),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ===== Error Icon Section =====
                Container(
                  padding: EdgeInsets.all(space * 2.2),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: theme.colorScheme.error,
                    size: 70,
                  ),
                ),

                SizedBox(height: space * 2),

                Text(
                  s.generic_error_message,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: space * 2),

                // ===== Transaction Info Card =====
                Card(
                  color: theme.cardColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: theme.dividerColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(space * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (orderInfo.isNotEmpty)
                          _infoRow(theme, s.payment_order_info, orderInfo),
                        if (amount.isNotEmpty)
                          _infoRow(
                            theme,
                            s.payment_amount,
                            s.price_display(amount, s.per_unit, ''),
                          ),
                        if (bank.isNotEmpty) _infoRow(theme, s.bank_name, bank),
                        if (transactionNo.isNotEmpty)
                          _infoRow(
                            theme,
                            s.payment_transaction_no,
                            transactionNo,
                          ),
                        if (txnRef.isNotEmpty)
                          _infoRow(theme, s.payment_ref, txnRef),
                        if (payDate.isNotEmpty)
                          _infoRow(theme, s.payment_time, payDate),
                        if (responseCode.isNotEmpty)
                          _infoRow(theme, s.payment_error_code, responseCode),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: space * 2),

                // ===== Retry Button =====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/collector-home'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: space * 1.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh),
                        SizedBox(width: space),
                        Text(
                          s.payment_retry,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
