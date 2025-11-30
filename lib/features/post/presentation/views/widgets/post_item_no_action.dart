import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/full_image_viewer.dart';
import 'package:flutter/material.dart';

class PostItemNoAction extends StatelessWidget {
  final BuildContext context;
  final String category;
  final String packageInformation;
  final String? imageUrl;
  const PostItemNoAction({
    super.key,
    required this.context,
    required this.category,
    required this.packageInformation,
    this.imageUrl,
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
                final displayImage = imageUrl ?? logo;
                showGeneralDialog(
                  context: context,
                  barrierLabel: 'Dismiss',
                  barrierColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.1,
                  ),
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (_, _, _) {
                    return FullImageViewer(
                      imagePath: displayImage,
                      isNetworkImage: imageUrl != null,
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
                tag: imageUrl ?? logo,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(spacing.screenPadding / 2),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          width: spacing.screenPadding * 4,
                          height: spacing.screenPadding * 4,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: spacing.screenPadding * 4,
                              height: spacing.screenPadding * 4,
                              color: theme.dividerColor.withValues(alpha: 0.2),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              logo,
                              width: spacing.screenPadding * 4,
                              height: spacing.screenPadding * 4,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          logo,
                          width: spacing.screenPadding * 4,
                          height: spacing.screenPadding * 4,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
