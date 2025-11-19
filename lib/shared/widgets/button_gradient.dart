import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Icon? icon;
  final bool? isEnabled;
  final Widget? child;

  const GradientButton({
    super.key,
    this.text,
    required this.onPressed,
    this.icon,
    this.isEnabled,
    this.child,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>();
    final paddingValue = spacing?.screenPadding ?? 16.0;

    final isEnabled = widget.isEnabled ?? true;

    final textStyle = TextStyle(
      color: theme.scaffoldBackgroundColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isEnabled ? AppColors.linearPrimary : null,
        color: isEnabled ? null : theme.disabledColor,
        borderRadius: BorderRadius.all(Radius.circular(paddingValue)),
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child:
            widget.child ??
            (widget.icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon!.icon,
                        color: theme.scaffoldBackgroundColor,
                      ),
                      const SizedBox(width: 8),
                      Text(widget.text ?? "", style: textStyle),
                    ],
                  )
                : Text(widget.text ?? "", style: textStyle)),
      ),
    );
  }
}
