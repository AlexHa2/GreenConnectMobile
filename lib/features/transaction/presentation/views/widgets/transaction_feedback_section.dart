import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionFeedbackSection extends StatelessWidget {
  final List<TransactionFeedback> feedbacks;
  final ThemeData theme;
  final double space;
  final S s;

  const TransactionFeedbackSection({
    super.key,
    required this.feedbacks,
    required this.theme,
    required this.space,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(space * 1.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.rate_review_outlined,
                color: theme.primaryColor,
                size: space * 2,
              ),
              SizedBox(width: space),
              Text(
                s.transaction_feedbacks,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: space * 1.5),
          Divider(height: 1, color: theme.dividerColor),
          SizedBox(height: space * 1.5),

          ...feedbacks.map((feedback) => Padding(
                padding: EdgeInsets.only(bottom: space * 1.5),
                child: _buildFeedbackCard(feedback),
              )).toList(),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(TransactionFeedback feedback) {
    return Container(
      padding: EdgeInsets.all(space * 1.25),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey.shade800.withOpacity(0.3)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(space * 0.75),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Rating Stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < feedback.rating
                        ? Icons.star
                        : Icons.star_border,
                    size: space * 1.75,
                    color: Colors.amber,
                  );
                }),
              ),

              // Date
              Text(
                _formatDateTime(feedback.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),

          if (feedback.comment != null && feedback.comment!.isNotEmpty) ...[
            SizedBox(height: space),
            Text(
              feedback.comment!,
              style: theme.textTheme.bodyMedium,
            ),
          ],

          SizedBox(height: space * 0.75),

          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: space * 1.25,
                color: theme.iconTheme.color?.withOpacity(0.6),
              ),
              SizedBox(width: space * 0.5),
              Text(
                '${s.provided_by} ${feedback.providedBy}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }
}
