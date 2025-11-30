import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class AIResultDialog extends StatelessWidget {
  final dynamic aiResponse;

  const AIResultDialog({
    super.key,
    required this.aiResponse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Row(
        children: [
          Text('🤖 ${S.of(context)!.ai_recognition}'),
          const Spacer(),
          _buildConfidenceBadge(theme),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              '📦 ${S.of(context)!.item}',
              aiResponse.itemName,
              isBold: true,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              '🏷️ ${S.of(context)!.category}',
              aiResponse.category,
            ),
            _buildInfoRow(
              context,
              '♻️ ${S.of(context)!.recyclable}',
              aiResponse.isRecyclable
                  ? S.of(context)!.yes
                  : S.of(context)!.no,
            ),
            if (aiResponse.estimatedAmount.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildInfoRow(
                context,
                '📊 ${S.of(context)!.estimated}',
                aiResponse.estimatedAmount,
              ),
            ],
            if (aiResponse.advice.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              Text(
                '💡 ${S.of(context)!.advice}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                aiResponse.advice,
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildInfoMessage(theme, context),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context)!.close),
        ),
      ],
    );
  }

  Widget _buildConfidenceBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: aiResponse.confidence >= 70
            ? theme.primaryColor.withValues(alpha: 0.2)
            : AppColors.warningUpdate.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${aiResponse.confidence.toStringAsFixed(0)}%',
        style: TextStyle(
          fontSize: 14,
          color: aiResponse.confidence >= 70
              ? theme.primaryColor
              : AppColors.warningUpdate,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoMessage(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: theme.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.of(context)!.info_auto_filled,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
