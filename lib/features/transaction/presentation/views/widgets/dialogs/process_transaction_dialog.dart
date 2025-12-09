import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ProcessTransactionDialog extends StatefulWidget {
  final String transactionId;
  final bool isApprove;
  final VoidCallback onSuccess;

  const ProcessTransactionDialog({
    super.key,
    required this.transactionId,
    required this.isApprove,
    required this.onSuccess,
  });

  @override
  State<ProcessTransactionDialog> createState() => _ProcessTransactionDialogState();
}

class _ProcessTransactionDialogState extends State<ProcessTransactionDialog> {
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.error_process_failed),
            backgroundColor: AppColors.danger,
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
          Icon(
            widget.isApprove ? Icons.check_circle : Icons.cancel,
            color: widget.isApprove ? theme.primaryColor : AppColors.danger,
          ),
          SizedBox(width: space),
          Expanded(
            child: Text(
              widget.isApprove ? s.approve_confirm : s.reject_confirm,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isApprove ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: space * 6,
            color: widget.isApprove ? theme.primaryColor : AppColors.danger,
          ),
          SizedBox(height: space * 1.5),
          Text(
            widget.isApprove ? s.approve_message : s.reject_message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: space * 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.enter_note, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: space * 0.5),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: s.enter_note,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(space * 0.75)),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isApprove ? theme.primaryColor : AppColors.danger,
            foregroundColor: theme.scaffoldBackgroundColor,
          ),
          child: _isLoading
              ? SizedBox(
                  width: space * 1.5,
                  height: space * 1.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.scaffoldBackgroundColor),
                  ),
                )
              : Text(widget.isApprove ? s.approve : s.reject),
        ),
      ],
    );
  }
}
