import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class LoadingInButton extends StatefulWidget {
  final String? text;
  final bool? isLoading;
  const LoadingInButton({super.key, this.text, this.isLoading});

  @override
  State<LoadingInButton> createState() => _LoadingInButtonState();
}

class _LoadingInButtonState extends State<LoadingInButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading == true) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: AppColors.background,
          strokeWidth: 2.5,
        ),
      );
    }
    return Text(widget.text ?? '');
  }
}
