import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class InputDetailsDialog extends StatefulWidget {
  final String transactionId;
  final VoidCallback onSuccess;

  const InputDetailsDialog({
    super.key,
    required this.transactionId,
    required this.onSuccess,
  });

  @override
  State<InputDetailsDialog> createState() => _InputDetailsDialogState();
}

class _InputDetailsDialogState extends State<InputDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _valueController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _weightController.dispose();
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Call API to input details
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.error_input_details_failed),
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
          Icon(Icons.edit, color: theme.primaryColor),
          SizedBox(width: space),
          Expanded(child: Text(s.input_details_title)),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.enter_weight, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: space * 0.5),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      hintText: s.weight_hint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(space * 0.75)),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return s.error_weight_required;
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return s.error_weight_invalid;
                      }
                      return null;
                    },
                  ),
                ],
              ),

              SizedBox(height: space * 1.5),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.enter_value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: space * 0.5),
                  TextFormField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      hintText: s.value_hint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(space * 0.75)),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return s.error_value_required;
                      }
                      final valueNum = double.tryParse(value);
                      if (valueNum == null || valueNum <= 0) {
                        return 'Invalid value';
                      }
                      return null;
                    },
                  ),
                ],
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
                    valueColor: AlwaysStoppedAnimation<Color>(theme.scaffoldBackgroundColor),
                  ),
                )
              : Text(s.submit_feedback),
        ),
      ],
    );
  }
}
