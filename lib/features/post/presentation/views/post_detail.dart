import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer_bottom_sheet.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/delete_post_dialog.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/info_row_widget.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_item_no_action.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_section_title.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/status_badge.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostDetailsPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;

  const PostDetailsPage({super.key, required this.initialData});

  @override
  ConsumerState<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends ConsumerState<PostDetailsPage> {
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
    final statusColor = PostStatusHelper.getStatusColor(
      context,
      PostStatus.parseStatus(status),
    );
    final statusText = PostStatusHelper.getLocalizedStatus(
      context,
      PostStatus.parseStatus(status),
    );
    final mustTakeAll = hasEntity
        ? entity.mustTakeAll
        : (widget.initialData['mustTakeAll'] ?? false);
    final isCollectorView = widget.initialData['isCollectorView'] == true;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              isCollectorView ? context.pop() : context.push('/list-post'),
        ),
        title: Text(s.detail),
        centerTitle: true,
        actions: [
          if (!isCollectorView &&
              PostStatus.parseStatus(status) == PostStatus.open)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () {
                context.push(
                  '/update-post',
                  extra: hasEntity
                      ? {
                          'id': entity.scrapPostId,
                          'title': entity.title,
                          'description': entity.description,
                          'address': entity.address,
                          'availableTimeRange': entity.availableTimeRange,
                          'items': entity.scrapPostDetails,
                          'mustTakeAll': entity.mustTakeAll,
                        }
                      : widget.initialData,
                );
              },
            ),

          if (!isCollectorView &&
              PostStatus.parseStatus(status) == PostStatus.open)
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
                        context.go('/list-post');
                      } else {
                        if (context.mounted) {
                          CustomToast.show(
                            context,
                            s.error_delete_post,
                            type: ToastType.error,
                          );
                        }
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatusBadge(text: statusText, color: statusColor),
                const Spacer(),
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

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.screenPadding),
                side: BorderSide(color: theme.dividerColor),
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.screenPadding),
                child: Column(
                  children: [
                    InfoRowWidget(
                      icon: Icons.calendar_today_rounded,
                      iconColor: theme.primaryColor,
                      label: s.pickup_time,
                      value: pickupTime,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: theme.dividerColor),
                    ),
                    InfoRowWidget(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.warning,
                      label: s.pickup_address,
                      value: pickupAddress,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: spacing.screenPadding * 2),
            if (mustTakeAll)
              Container(
                margin: EdgeInsets.only(bottom: spacing.screenPadding),
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.screenPadding,
                  vertical: spacing.screenPadding,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                  border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.all_inclusive_rounded,
                      color: theme.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: spacing.screenPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.must_take_all,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          Text(
                            s.must_take_all_desc, // VD: "Collectors must take all items listed below."
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.primaryColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // ---------------------------------------------------------
            SizedBox(height: spacing.screenPadding),

            if (!isCollectorView &&
                (status.toString().toLowerCase() == 'partiallybooked' ||
                    status.toString().toLowerCase() == 'fullybooked')) ...[
              GradientButton(
                onPressed: () {
                  context.push(
                    '/offers-list',
                    extra: {'postId': scrapPostId, 'isCollectorView': false},
                  );
                },
                text: s.view_offers,
                icon: Icon(
                  Icons.receipt_long_rounded,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
              SizedBox(height: spacing.screenPadding * 2),
            ],

            PostSectionTitle(title: "${s.list} ${s.items}"),
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
                final itemStatus = PostDetailStatus.parseStatus(
                  detail.status ?? 'available',
                );
                return Padding(
                  padding: EdgeInsets.only(bottom: spacing.screenPadding / 2),
                  child: PostItemNoAction(
                    context: context,
                    category: detail.scrapCategory?.categoryName ?? s.unknown,
                    packageInformation: detail.amountDescription,
                    imageUrl: detail.imageUrl,
                    status: itemStatus,
                    isCollectorView: isCollectorView,
                  ),
                );
              })
            else
              ...(widget.initialData['scrapItems'] as List<dynamic>? ?? []).map(
                (item) {
                  final map = item as Map<String, dynamic>;
                  final itemStatus = PostDetailStatus.parseStatus(
                    map['status'] ?? 'available',
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PostItemNoAction(
                      context: context,
                      category: map['category'] ?? '',
                      packageInformation: map['amountDescription'] ?? '',
                      imageUrl: map['imageUrl'] ?? '',
                      status: itemStatus,
                      isCollectorView: isCollectorView,
                    ),
                  );
                },
              ),

            SizedBox(height: spacing.screenPadding * 4),
          ],
        ),
      ),
      floatingActionButton:
          isCollectorView &&
              hasEntity &&
              PostStatus.parseStatus(status) != PostStatus.fullyBooked
          ? FloatingActionButton.extended(
              backgroundColor: theme.primaryColor,
              elevation: 4,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: CreateOfferBottomSheet(post: entity),
                  ),
                ).then((result) {
                  if (result == true && context.mounted) {
                    // Offer created successfully - refresh post detail
                    // Toast already shown in bottom sheet, just refresh
                    ref
                        .read(scrapPostViewModelProvider.notifier)
                        .fetchDetail(scrapPostId);
                  }
                });
              },
              icon: Icon(
                Icons.local_offer_rounded,
                color: theme.scaffoldBackgroundColor,
              ),
              label: Text(
                s.create_offer,
                style: TextStyle(
                  color: theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
