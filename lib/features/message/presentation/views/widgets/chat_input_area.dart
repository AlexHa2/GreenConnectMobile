import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ChatInputArea extends StatelessWidget {
  final Function(String text) onSend;
  final VoidCallback onAttach;

  const ChatInputArea({
    super.key,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final controller = TextEditingController();
    final s = S.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.dividerColor.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.screenPadding,
            vertical: spacing.screenPadding / 1.5,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: s.message_hint,
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing.screenPadding,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: theme.primaryColor),
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  onSend(controller.text.trim());
                  controller.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
