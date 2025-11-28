import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/full_image_viewer.dart';
import 'package:flutter/material.dart';

class PostItemNoAction extends StatelessWidget {
  final BuildContext context;
  final String category;
  final String packageInformation;
  const PostItemNoAction({
    super.key,
    required this.context,
    required this.category,
    required this.packageInformation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final spacing = theme.extension<AppSpacing>()!;
    const logo = "assets/images/green_connect_logo.png";
    return Card(
      margin: EdgeInsets.only(bottom: spacing.screenPadding),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(spacing.screenPadding),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.screenPadding * 2,
          vertical: spacing.screenPadding,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: spacing.screenPadding * 1.2,
                    ),
                  ),
                  SizedBox(height: spacing.screenPadding / 2),
                  Text.rich(
                    TextSpan(
                      style: textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: packageInformation,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierLabel: 'Dismiss',
                  barrierColor: AppColors.textPrimary.withValues(alpha: 0.1),
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (_, _, _) {
                    return FullImageViewer(
                      imagePath: logo,
                      onClose: () => Navigator.pop(context),
                    );
                  },
                  transitionBuilder: (_, animation, _, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.95,
                          end: 1.0,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                );
              },
              child: Hero(
                tag: logo,
                child: Image.asset(
                  logo,
                  width: spacing.screenPadding * 4,
                  height: spacing.screenPadding * 4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
