import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionInfoSection extends StatelessWidget {
  final TransactionEntity transaction;
  final ThemeData theme;
  final double space;
  final S s;

  const TransactionInfoSection({
    super.key,
    required this.transaction,
    required this.theme,
    required this.space,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space / 2),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.transaction_information,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: space),
          Divider(height: 1, color: theme.dividerColor),
          SizedBox(height: space),

          // Transaction ID
          _buildInfoRow(
            icon: Icons.tag,
            label: s.transaction_id,
            value: transaction.transactionId,
          ),
          SizedBox(height: space),

          // Total Price
          _buildInfoRow(
            icon: Icons.attach_money,
            label: s.total_price,
            value: transaction.totalPrice.toStringAsFixed(2),
            valueColor: theme.primaryColor,
            valueWeight: FontWeight.bold,
          ),

          SizedBox(height: space),

          // Check-in Time
          if (transaction.checkInTime != null) ...[
            _buildInfoRow(
              icon: Icons.location_on,
              label: s.check_in_time,
              value: _formatDateTime(transaction.checkInTime!),
            ),
            SizedBox(height: space),
          ],

          // Created Time
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: s.transaction_created_time,
            value: _formatDateTime(transaction.createdAt),
          ),

          // Updated Time
          if (transaction.updatedAt != null) ...[
            SizedBox(height: space),
            _buildInfoRow(
              icon: Icons.update,
              label: s.transaction_updated_time,
              value: _formatDateTime(transaction.updatedAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: space * 1.5,
          color: theme.primaryColor.withValues(alpha: 0.7),
        ),
        SizedBox(width: space),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              SizedBox(height: space / 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: valueWeight ?? FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
