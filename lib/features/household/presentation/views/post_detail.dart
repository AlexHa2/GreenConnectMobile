import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/delete_post_dialog.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/post_item_no_action.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;

  const PostDetailsScreen({super.key, required this.initialData});

  @override
  ConsumerState<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends ConsumerState<PostDetailsScreen> {
  late String scrapPostId;

  @override
  void initState() {
    super.initState();
    scrapPostId =
        (widget.initialData['postId'] ?? widget.initialData['id'] ?? '')
            .toString();

    if (scrapPostId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scrapPostViewModelProvider.notifier).fetchDetail(scrapPostId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- Theme Accessors ---
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final s = S.of(context)!;
    final spacing = theme.extension<AppSpacing>()!;

    // --- State & Data Logic ---
    final postState = ref.watch(scrapPostViewModelProvider);
    final ScrapPostEntity? entity = postState.detailData;
    final bool hasEntity = entity != null;

    final title = hasEntity
        ? entity.title
        : (widget.initialData['title'] ?? '');
    final description = hasEntity
        ? entity.description
        : (widget.initialData['description'] ?? '');

    final status = hasEntity
        ? (entity.status ?? 'available')
        : (widget.initialData['status'] ?? 'available');

    final pickupTime = hasEntity
        ? entity.availableTimeRange
        : (widget.initialData['pickupTime'] ??
              widget.initialData['availableTimeRange'] ??
              '');

    final pickupAddress = hasEntity
        ? entity.address
        : (widget.initialData['pickupAddress'] ??
              widget.initialData['address'] ??
              '');

    // --- Date Parsing ---
    DateTime? dateObj;
    if (hasEntity) {
      dateObj = entity.createdAt;
    } else {
      final dateStr =
          widget.initialData['postedDate'] ?? widget.initialData['createdAt'];
      if (dateStr != null) {
        dateObj = DateTime.tryParse(dateStr.toString());
      }
    }

    final createdAgo = dateObj != null
        ? TimeAgoHelper.format(context, dateObj)
        : '';

    // --- Status Helper ---
    final statusColor = PostStatusHelper.getStatusColor(context, status);
    final statusText = PostStatusHelper.getLocalizedStatus(context, status);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(s.detail),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              context.pushNamed(
                'update-post',
                extra: hasEntity
                    ? {
                        'id': entity.scrapPostId,
                        'title': entity.title,
                        'description': entity.description,
                        'address': entity.address,
                        'availableTimeRange': entity.availableTimeRange,
                        'items': entity.scrapPostDetails,
                      }
                    : widget.initialData,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => DeletePostDialog(
                  onDelete: () async {
                    Navigator.pop(dialogContext);
                    final success = await ref
                        .read(scrapPostViewModelProvider.notifier)
                        .deletePost(scrapPostId);
                    if (success && context.mounted) {
                      context.pop();
                    }
                  },
                  onCancel: () => Navigator.pop(dialogContext),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(scrapPostViewModelProvider.notifier)
              .fetchDetail(scrapPostId);
        },
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.screenPadding,
            vertical: spacing.screenPadding,
          ),
          children: [
            // --- SECTION 1: Header (Status + Date) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: textTheme.labelMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Time Ago
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  createdAgo,
                  style: textTheme.bodySmall?.copyWith(
                    color: textTheme.bodyMedium?.color,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing.screenPadding),

            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),

            SizedBox(height: spacing.screenPadding / 2),

            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(height: 1.5),
            ),

            SizedBox(height: spacing.screenPadding * 1.5),

            Container(
              padding: EdgeInsets.all(spacing.screenPadding),
              decoration: BoxDecoration(
                color: theme.cardColor, // AppColors.surface
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                // Border màu AppColors.border
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 20,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.pickup_time,
                              // labelLarge / bodyMedium
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pickupTime,
                              // titleSmall / bodyLarge
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: theme.dividerColor),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 20,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.pickup_address, style: textTheme.bodyMedium),
                            const SizedBox(height: 2),
                            Text(
                              pickupAddress,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: spacing.screenPadding * 2),

            if (status.toString().toLowerCase() == 'partiallybooked' ||
                status.toString().toLowerCase() == 'fullybooked') ...[
              GradientButton(
                onPressed: () {},
                text: s.transaction_detail,
                icon: Icon(
                  Icons.receipt_long_rounded,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
              SizedBox(height: spacing.screenPadding * 2),
            ],

            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text("${s.list} ${s.items}", style: textTheme.titleLarge),
              ],
            ),
            SizedBox(height: spacing.screenPadding),

            if (postState.isLoadingDetail && !hasEntity)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (hasEntity)
              ...entity.scrapPostDetails.map((detail) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PostItemNoAction(
                    context: context,
                    category: detail.scrapCategory?.categoryName ?? 'Unknown',
                    packageInformation: detail.amountDescription,
                  ),
                );
              })
            else
              ...(widget.initialData['scrapItems'] as List<dynamic>? ?? []).map((
                item,
              ) {
                final map = item as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PostItemNoAction(
                    context: context,
                    category: map['category'] ?? '',
                    packageInformation:
                        '${s.quantity}: ${map['quantity']}, ${s.weight}: ${map['weight']}kg',
                  ),
                );
              }),

            SizedBox(height: spacing.screenPadding * 4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        shape: const CircleBorder(),
        elevation: 4,
        onPressed: () {},
        child: Icon(
          Icons.message_rounded,
          color: theme.scaffoldBackgroundColor,
          size: 24,
        ),
      ),
    );
  }
}
