import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Smart amount description field that works with or without AI
class AmountDescriptionField extends StatefulWidget {
  final TextEditingController controller;
  final String? aiSuggestion;
  final bool isAIAnalyzing;
  final VoidCallback? onAcceptAI;
  final VoidCallback? onRejectAI;
  final FormFieldValidator<String>? validator;

  const AmountDescriptionField({
    super.key,
    required this.controller,
    this.aiSuggestion,
    this.isAIAnalyzing = false,
    this.onAcceptAI,
    this.onRejectAI,
    this.validator,
  });

  @override
  State<AmountDescriptionField> createState() => _AmountDescriptionFieldState();
}

class _AmountDescriptionFieldState extends State<AmountDescriptionField> {
  bool _showAISuggestion = false;
  String? _lastAISuggestion;

  @override
  void didUpdateWidget(AmountDescriptionField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu controller bị clear (reset), ẩn box gợi ý
    if (widget.controller.text.isEmpty && _showAISuggestion) {
      setState(() {
        _showAISuggestion = false;
        _lastAISuggestion = null;
      });
      return;
    }
    // Nếu có aiSuggestion mới, tự động hiện box gợi ý
    if (widget.aiSuggestion != null &&
        widget.aiSuggestion != _lastAISuggestion &&
        widget.aiSuggestion!.isNotEmpty) {
      setState(() {
        _showAISuggestion = true;
        _lastAISuggestion = widget.aiSuggestion;
      });
    }
  }

  void _acceptAISuggestion() {
    if (widget.aiSuggestion != null) {
      widget.controller.text = widget.aiSuggestion!;
      setState(() {
        _showAISuggestion = false;
      });
      widget.onAcceptAI?.call();
    }
  }

  void _rejectAISuggestion() {
    setState(() {
      _showAISuggestion = false;
    });
    widget.onRejectAI?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.amount_description,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: space * 0.5),

        // AI Analyzing indicator
        if (widget.isAIAnalyzing)
          Container(
            padding: EdgeInsets.all(space),
            margin: EdgeInsets.only(bottom: space * 0.75),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(space * 0.75),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(width: space),
                Expanded(
                  child: Text(
                    s.ai_analyzing,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // AI Suggestion card
        if (_showAISuggestion && widget.aiSuggestion != null)
          Container(
            padding: EdgeInsets.all(space),
            margin: EdgeInsets.only(bottom: space * 0.75),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withValues(alpha: 0.1),
                  theme.primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(space),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(space * 0.4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(space * 0.4),
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                    SizedBox(width: space * 0.5),
                    Text(
                      s.ai_suggestion,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: space * 0.75),
                Text(
                  widget.aiSuggestion!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: space),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _rejectAISuggestion,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.dividerColor),
                          padding: EdgeInsets.symmetric(vertical: space * 0.5),
                        ),
                        icon: Icon(
                          Icons.close,
                          size: 16,
                          color: theme.hintColor,
                        ),
                        label: Text(
                          s.reject,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: space),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _acceptAISuggestion,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: space * 0.5),
                        ),
                        icon: const Icon(Icons.check, size: 16),
                        label: Text(
                          s.accept,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // Main text field
        TextFormField(
          controller: widget.controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: s.amount_description_hint,
            helperText: s.amount_description_helper,
            helperMaxLines: 2,
            helperStyle: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: theme.disabledColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(space),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(space),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(space),
              borderSide: BorderSide(color: theme.primaryColor, width: 2),
            ),
          ),
          validator: widget.validator,
        ),

        // Quick templates
        if (!widget.isAIAnalyzing && widget.controller.text.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: space * 0.75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.quick_templates,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: space * 0.5),
                Wrap(
                  spacing: space * 0.5,
                  runSpacing: space * 0.5,
                  children: [
                    _TemplateChip(
                      label: s.template_small_bag,
                      onTap: () {
                        widget.controller.text = s.template_small_bag;
                        setState(() {});
                      },
                    ),
                    _TemplateChip(
                      label: s.template_medium_box,
                      onTap: () {
                        widget.controller.text = s.template_medium_box;
                        setState(() {});
                      },
                    ),
                    _TemplateChip(
                      label: s.template_large_bundle,
                      onTap: () {
                        widget.controller.text = s.template_large_bundle;
                        setState(() {});
                      },
                    ),
                    _TemplateChip(
                      label: s.template_multiple_items,
                      onTap: () {
                        widget.controller.text = s.template_multiple_items;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TemplateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TemplateChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(space * 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: space * 0.75,
          vertical: space * 0.4,
        ),
        decoration: BoxDecoration(
          color: theme.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(space * 2),
          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, size: 14, color: theme.primaryColor),
            SizedBox(width: space * 0.3),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
