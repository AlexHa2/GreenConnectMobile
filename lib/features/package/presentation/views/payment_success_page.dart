
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentSuccessPage extends StatelessWidget {
  final Map<String, dynamic>? paymentInfo;
  const PaymentSuccessPage({super.key, this.paymentInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    String amount = paymentInfo?['amount'] ?? '';
    String bank = paymentInfo?['bank'] ?? '';
    String orderInfo = paymentInfo?['orderInfo'] ?? '';
    String payDate = paymentInfo?['payDate'] ?? '';
    String transactionNo = paymentInfo?['transactionNo'] ?? '';
    String txnRef = paymentInfo?['txnRef'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(s.payment_success_title), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(space * 2),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ===== Success Icon Section =====
                Container(
                  padding: EdgeInsets.all(space * 2.2),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: theme.primaryColor,
                    size: 70,
                  ),
                ),

                SizedBox(height: space * 2),

                Text(
                  s.payment_success_message,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: space * 2),

                // ===== Transaction Details Card =====
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
                        if (bank.isNotEmpty)
                          _infoRow(theme, s.payment_bank, bank),
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
                      ],
                    ),
                  ),
                ),

                SizedBox(height: space * 2),

                // ===== Back Button =====
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
                        const Icon(Icons.home_rounded),
                        SizedBox(width: space),
                        Text(
                          s.back,
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
