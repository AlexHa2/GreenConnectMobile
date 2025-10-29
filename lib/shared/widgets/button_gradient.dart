import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon? icon;
  final bool? isEnabled;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isEnabled,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final isEnabled = widget.isEnabled ?? true;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isEnabled == true ? AppColors.linearPrimary : null,
        borderRadius: BorderRadius.all(Radius.circular(spacing.screenPadding)),
      ),
      child: ElevatedButton(
        onPressed: isEnabled == true ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: widget.icon == null
            ? Text(
                widget.text,
                style: TextStyle(
                  color: theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon!.icon, color: theme.scaffoldBackgroundColor),
                  const SizedBox(width: 8),
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: theme.scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
