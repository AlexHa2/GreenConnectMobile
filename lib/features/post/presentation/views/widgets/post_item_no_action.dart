import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_detail_status_helper.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/full_image_viewer.dart';
import 'package:flutter/material.dart';

class PostItemNoAction extends StatelessWidget {
  final BuildContext context;
  final String category;
  final String packageInformation;
  final String? imageUrl;
  final PostDetailStatus? status;
  final bool isCollectorView;

  const PostItemNoAction({
    super.key,
    required this.context,
    required this.category,
    required this.packageInformation,
    this.imageUrl,
    this.status,
    this.isCollectorView = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    const logo = "assets/images/green_connect_logo.png";

    // Determine if item is available
    final currentStatus = status ?? PostDetailStatus.available;
    final isAvailable = currentStatus == PostDetailStatus.available;
    final isDisabled = isCollectorView && !isAvailable;
    final opacity = isDisabled ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(space * 1.2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    final displayImage = imageUrl ?? logo;
                    showGeneralDialog(
                      context: context,
                      barrierLabel: 'Dismiss',
                      barrierColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      transitionDuration: const Duration(
                        milliseconds: 250,
                      ),
                      pageBuilder: (_, __, ___) {
                        return FullImageViewer(
                          imagePath: displayImage,
                          isNetworkImage: imageUrl != null,
                          onClose: () => Navigator.pop(context),
                        );
                      },
                      transitionBuilder: (_, animation, __, child) {
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
            child: Padding(
              padding: EdgeInsets.all(space / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image block
                  Hero(
                    tag: imageUrl ?? logo,
                    child: Container(
                      width: space * 4.2,
                      height: space * 4.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space * 0.9),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.14),
                          width: 1.25,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(space * 0.8),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(
                                    color: theme.primaryColor
                                        .withValues(alpha: 0.05),
                                    child: Center(
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          valueColor: AlwaysStoppedAnimation(
                                            theme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: theme.primaryColor
                                        .withValues(alpha: 0.05),
                                    child: Image.asset(
                                      logo,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color:
                                    theme.primaryColor.withValues(alpha: 0.05),
                                child: Image.asset(
                                  logo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(width: space * 0.75),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: space * 0.4,
                          runSpacing: space * 0.3,
                          children: [
                            _ChipBadge(
                              label: PostDetailStatusHelper.getLocalizedStatus(
                                context,
                                currentStatus,
                              ),
                              icon: Icons.check_circle_rounded,
                              color: PostDetailStatusHelper.getStatusColor(
                                context,
                                currentStatus,
                              ),
                              bgAlpha: 0.12,
                            ),
                            _ChipBadge(
                              label: category,
                              icon: Icons.category_rounded,
                              color: theme.primaryColor,
                              bgAlpha: 0.1,
                            ),
                          ],
                        ),
                        SizedBox(height: space * 0.5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.inventory_2_rounded,
                                size: 16,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.72),
                              ),
                            ),
                            SizedBox(width: space * 0.4),
                            Expanded(
                              child: Text(
                                packageInformation,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.3,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: space * 0.5),

                  // Tap indicator icon
                  Container(
                    padding: EdgeInsets.all(space * 0.4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(space * 0.6),
                      border: Border.all(
                        color: theme.primaryColor.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Icon(
                      Icons.zoom_in_rounded,
                      size: 18,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipBadge extends StatelessWidget {
  const _ChipBadge({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgAlpha,
  });

  final String label;
  final IconData icon;
  final Color color;
  final double bgAlpha;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: bgAlpha),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.38,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
