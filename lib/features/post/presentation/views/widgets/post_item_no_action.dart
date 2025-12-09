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
      child: Container(
        margin: EdgeInsets.only(bottom: space),
        decoration: BoxDecoration(
          color: isDisabled
              ? theme.cardColor.withValues(alpha: 0.6)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(space * 1.25),
          border: Border.all(
            color: isDisabled
                ? theme.dividerColor.withValues(alpha: 0.3)
                : theme.dividerColor.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(space * 1.25),
          child: Stack(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isDisabled
                      ? null
                      : () {
                          final displayImage = imageUrl ?? logo;
                          showGeneralDialog(
                            context: context,
                            barrierLabel: 'Dismiss',
                            barrierColor: theme.colorScheme.onSurface
                                .withValues(alpha: 0.8),
                            transitionDuration: const Duration(
                              milliseconds: 250,
                            ),
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
                  child: Padding(
                    padding: EdgeInsets.all(space * 0.75),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image with enhanced styling - compact size
                        Hero(
                          tag: imageUrl ?? logo,
                          child: Container(
                            width: space * 4,
                            height: space * 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(space * 0.75),
                              border: Border.all(
                                color: theme.primaryColor.withValues(
                                  alpha: 0.15,
                                ),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(space * 0.6),
                              child: imageUrl != null
                                  ? Image.network(
                                      imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          color: theme.primaryColor.withValues(
                                            alpha: 0.05,
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                      theme.primaryColor,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                      color: theme.primaryColor.withValues(
                                        alpha: 0.05,
                                      ),
                                      child: Image.asset(
                                        logo,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        SizedBox(width: space * 0.75),

                        // Content with enhanced typography - flexible layout
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Status and Category badges
                              Row(
                                children: [
                                  // Status badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: space * 0.6,
                                      vertical: space * 0.25,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          PostDetailStatusHelper.getStatusColor(
                                            context,
                                            currentStatus,
                                          ).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(
                                        space * 0.4,
                                      ),
                                      border: Border.all(
                                        color:
                                            PostDetailStatusHelper.getStatusColor(
                                              context,
                                              currentStatus,
                                            ).withValues(alpha: 0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      PostDetailStatusHelper.getLocalizedStatus(
                                        context,
                                        currentStatus,
                                      ),
                                      style: textTheme.labelSmall?.copyWith(
                                        color:
                                            PostDetailStatusHelper.getStatusColor(
                                              context,
                                              currentStatus,
                                            ),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: space * 0.4),
                                  // Category badge - compact design
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: space * 0.6,
                                        vertical: space * 0.25,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.primaryColor.withValues(
                                              alpha: 0.12,
                                            ),
                                            theme.primaryColor.withValues(
                                              alpha: 0.06,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          space * 0.5,
                                        ),
                                        border: Border.all(
                                          color: theme.primaryColor.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.category_rounded,
                                            size: 12,
                                            color: theme.primaryColor,
                                          ),
                                          SizedBox(width: space * 0.25),
                                          Flexible(
                                            child: Text(
                                              category,
                                              style: textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: theme.primaryColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 11,
                                                    letterSpacing: 0.2,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: space * 0.4),

                              // Package information - responsive text
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.inventory_2_rounded,
                                      size: 16,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
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
                            borderRadius: BorderRadius.circular(space * 0.5),
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
              // Disabled overlay for collector view
              if (isDisabled)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(space * 1.25),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: space * 0.8,
                          vertical: space * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(space * 0.6),
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            SizedBox(width: space * 0.3),
                            Text(
                              PostDetailStatusHelper.getLocalizedStatus(
                                context,
                                currentStatus,
                              ),
                              style: textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
