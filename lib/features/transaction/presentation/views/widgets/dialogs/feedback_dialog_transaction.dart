import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class FeedbackDialogTransaction extends StatefulWidget {
  final String transactionId;
  final VoidCallback onSuccess;

  const FeedbackDialogTransaction({
    super.key,
    required this.transactionId,
    required this.onSuccess,
  });

  @override
  State<FeedbackDialogTransaction> createState() => _FeedbackDialogTransactionState();
}

class _FeedbackDialogTransactionState extends State<FeedbackDialogTransaction> {
  int _rating = 5;
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Call API to submit feedback
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.error_feedback_failed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.rate_review, color: theme.primaryColor),
          SizedBox(width: space),
          Expanded(child: Text(s.provide_feedback)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.how_was_your_transaction,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: space * 1.5),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: space * 3,
                    color: AppColors.warning,
                  ),
                );
              }),
            ),

            SizedBox(height: space * 1.5),

            // Comment TextField
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: s.your_review,
                hintText: s.your_review_hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(space * 0.75),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              maxLength: 500,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.scaffoldBackgroundColor,
          ),
          child: _isLoading
              ? SizedBox(
                  width: space * 1.5,
                  height: space * 1.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.scaffoldBackgroundColor,
                    ),
                  ),
                )
              : Text(s.submit_feedback),
        ),
      ],
    );
  }
}
