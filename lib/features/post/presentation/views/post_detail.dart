import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer_bottom_sheet.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_supplementary_offer_bottom_sheet.dart';
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
  bool _isCheckingAcceptedOffer = false;

  @override
  void initState() {
    super.initState();
    scrapPostId =
        (widget.initialData['postId'] ?? widget.initialData['id'] ?? '')
            .toString();

    if (scrapPostId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scrapPostViewModelProvider.notifier).fetchDetail(scrapPostId);
        _checkAcceptedOffer();
      });
    }
  }

  Future<void> _checkAcceptedOffer() async {
    final isCollectorView = widget.initialData['isCollectorView'] == true;
    if (!isCollectorView) return;

    setState(() {
      _isCheckingAcceptedOffer = true;
    });

    try {
      // Check if collector has ANY offer (not just accepted) for this post
      // This allows showing "Buy More" button even if offer is pending
      await ref
          .read(offerViewModelProvider.notifier)
          .fetchOffersByPost(
            postId: scrapPostId,
            status: null, // Check all offers, not just accepted
            page: 1,
            size: 1,
          );
      
      if (mounted) {
        setState(() {
          _isCheckingAcceptedOffer = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingAcceptedOffer = false;
        });
      }
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

    final title =
        hasEntity ? entity.title : (widget.initialData['title'] ?? '');
    final description = hasEntity
        ? entity.description
        : (widget.initialData['description'] ?? '');

    final status = hasEntity
        ? (entity.status ?? 'available')
        : (widget.initialData['status'] ?? 'available');

    final timeSlots =
        hasEntity ? (entity.scrapPostTimeSlots) : <ScrapPostTimeSlotEntity>[];

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

    final createdAgo =
        dateObj != null ? TimeAgoHelper.format(context, dateObj) : '';

    // --- Status Helper ---
    final parsedStatus = PostStatus.parseStatus(status);
    final statusColor = PostStatusHelper.getStatusColor(
      context,
      parsedStatus,
    );
    final statusText = PostStatusHelper.getLocalizedStatus(
      context,
      parsedStatus,
    );
    final mustTakeAll = hasEntity
        ? entity.mustTakeAll
        : (widget.initialData['mustTakeAll'] ?? false);
    final isCollectorView = widget.initialData['isCollectorView'] == true;

    final isBooked = status.toString().toLowerCase() == 'partiallybooked' ||
        status.toString().toLowerCase() == 'fullybooked';

    return Scaffold(
      // backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(scrapPostViewModelProvider.notifier)
              .fetchDetail(scrapPostId);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: theme.colorScheme.surface,
              elevation: 0.5,
              leading: BackButton(
                onPressed: () => isCollectorView
                    ? context.pop()
                    : context.push('/household-list-post'),
              ),
              title: Text(s.detail),
              actions: [
                if (!isCollectorView && parsedStatus == PostStatus.open)
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () {
                      context.push(
                        '/update-post',
                        extra: hasEntity
                            ? {
                                'id': entity.scrapPostId,
                                'postId': entity.scrapPostId,
                                'title': entity.title,
                                'description': entity.description,
                                'address': entity.address,
                                'availableTimeRange':
                                    entity.availableTimeRange ?? '',
                                'items': entity.scrapPostDetails,
                                'timeSlots': entity.scrapPostTimeSlots,
                                'mustTakeAll': entity.mustTakeAll,
                                'location': entity.location != null
                                    ? {
                                        'latitude': entity.location!.latitude,
                                        'longitude': entity.location!.longitude,
                                      }
                                    : null,
                              }
                            : widget.initialData,
                      );
                    },
                  ),
                if (!isCollectorView && parsedStatus == PostStatus.open)
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.danger),
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(spacing.screenPadding * 2.8),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: spacing.screenPadding,
                    right: spacing.screenPadding,
                    bottom: spacing.screenPadding,
                  ),
                  child: _MetaHeader(
                    statusText: statusText,
                    statusColor: statusColor,
                    createdAgo: createdAgo,
                    mustTakeAll: mustTakeAll,
                    spacing: spacing,
                    textTheme: textTheme,
                    primaryColor: theme.primaryColor,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.screenPadding,
                vertical: spacing.screenPadding,
              ),
              sliver: SliverList.list(
                children: [
                  _TitleSection(
                    title: title,
                    description: description,
                    isLoading: postState.isLoadingDetail && !hasEntity,
                    spacing: spacing,
                    textTheme: textTheme,
                  ),
                  SizedBox(height: spacing.screenPadding),
                  if (timeSlots.isNotEmpty)
                    _SectionCard(
                      spacing: spacing,
                      child: _TimeSlotsSection(
                        timeSlots: timeSlots,
                        textTheme: textTheme,
                        spacing: spacing,
                        title: s.pickup_time,
                        isCollectorView: isCollectorView,
                        s: s,
                      ),
                    ),
                  if (timeSlots.isNotEmpty)
                    SizedBox(height: spacing.screenPadding),
                  _SectionCard(
                    spacing: spacing,
                    child: InfoRowWidget(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.warning,
                      label: s.pickup_address,
                      value: pickupAddress,
                    ),
                  ),
                  if (!isCollectorView && isBooked) ...[
                    SizedBox(height: spacing.screenPadding * 1.5),
                    GradientButton(
                      onPressed: () {
                        context.push(
                          '/offers-list',
                          extra: {
                            'postId': scrapPostId,
                            'isCollectorView': false
                          },
                        );
                      },
                      text: s.view_offers,
                      icon: Icon(
                        Icons.receipt_long_rounded,
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                  SizedBox(height: spacing.screenPadding * 1.5),
                  PostSectionTitle(title: "${s.list} ${s.items}"),
                  SizedBox(height: spacing.screenPadding / 2),
                  _ItemsSection(
                    isLoading: postState.isLoadingDetail && !hasEntity,
                    hasEntity: hasEntity,
                    entity: entity,
                    initialData: widget.initialData,
                    spacing: spacing,
                    isCollectorView: isCollectorView,
                    s: s,
                  ),
                  SizedBox(height: spacing.screenPadding * 3),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          isCollectorView && hasEntity && parsedStatus != PostStatus.fullyBooked
              ? SafeArea(
                  minimum: EdgeInsets.fromLTRB(
                    spacing.screenPadding,
                    spacing.screenPadding / 2,
                    spacing.screenPadding,
                    spacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      // Mua thêm button (40%)
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: _isCheckingAcceptedOffer
                              ? null
                              : () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets.bottom,
                                      ),
                                      child:
                                          CreateSupplementaryOfferBottomSheet(
                                        post: entity,
                                      ),
                                    ),
                                  ).then((result) {
                                    if (result == true && context.mounted) {
                                      ref
                                          .read(
                                              scrapPostViewModelProvider
                                                  .notifier)
                                          .fetchDetail(scrapPostId);
                                      _checkAcceptedOffer();
                                    }
                                  });
                                },
                          icon: Icon(
                            Icons.add_shopping_cart_rounded,
                            color: theme.primaryColor,
                          ),
                          label: Text(
                            s.buy_more,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: theme.primaryColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.screenPadding,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.screenPadding * 0.75),
                      // Tạo Offer button (60% - Primary)
                      Expanded(
                        flex: 3,
                        child: GradientButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets.bottom,
                                ),
                                child: CreateOfferBottomSheet(post: entity),
                              ),
                            ).then((result) {
                              if (result == true && context.mounted) {
                                ref
                                    .read(scrapPostViewModelProvider.notifier)
                                    .fetchDetail(scrapPostId);
                                _checkAcceptedOffer();
                              }
                            });
                          },
                          text: s.create_offer,
                          icon: Icon(
                            Icons.local_offer_rounded,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
    );
  }
}

class _MetaHeader extends StatelessWidget {
  const _MetaHeader({
    required this.statusText,
    required this.statusColor,
    required this.createdAgo,
    required this.mustTakeAll,
    required this.spacing,
    required this.textTheme,
    required this.primaryColor,
  });

  final String statusText;
  final Color statusColor;
  final String createdAgo;
  final bool mustTakeAll;
  final AppSpacing spacing;
  final TextTheme textTheme;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StatusBadge(text: statusText, color: statusColor),
            if (mustTakeAll) ...[
              SizedBox(width: spacing.screenPadding / 2),
              Chip(
                label: Text(
                  S.of(context)!.must_take_all,
                  style: textTheme.bodySmall?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                backgroundColor: primaryColor.withValues(alpha: 0.08),
                side: BorderSide(color: primaryColor.withValues(alpha: 0.25)),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(spacing.screenPadding * 2),
                ),
              ),
            ],
            const Spacer(),
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: textTheme.bodySmall?.color,
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
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    required this.spacing,
  });

  final Widget child;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0.5,
      shadowColor: theme.shadowColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: child,
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({
    required this.title,
    required this.description,
    required this.isLoading,
    required this.spacing,
    required this.textTheme,
  });

  final String title;
  final String description;
  final bool isLoading;
  final AppSpacing spacing;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonBox(width: 220, height: 26, radius: 8),
          SizedBox(height: spacing.screenPadding / 2),
          const _SkeletonBox(width: double.infinity, height: 16, radius: 6),
          SizedBox(height: spacing.screenPadding / 4),
          const _SkeletonBox(width: double.infinity, height: 16, radius: 6),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        SizedBox(height: spacing.screenPadding / 2),
        Text(
          description,
          style: textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

class _TimeSlotsSection extends StatelessWidget {
  const _TimeSlotsSection({
    required this.timeSlots,
    required this.textTheme,
    required this.spacing,
    required this.title,
    required this.isCollectorView,
    required this.s,
  });

  final List<ScrapPostTimeSlotEntity> timeSlots;
  final TextTheme textTheme;
  final AppSpacing spacing;
  final String title;
  final bool isCollectorView;
  final S s;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing.screenPadding / 2),
        ...timeSlots.map(
          (slot) {
            final date = slot.specificDate;
            final start = slot.startTime;
            final end = slot.endTime;
            final isSlotBooked = slot.isBooked == true;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.08),
                        borderRadius:
                            BorderRadius.circular(spacing.screenPadding),
                      ),
                      child: const Icon(
                        Icons.schedule_rounded,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding / 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  date,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (!isCollectorView && isSlotBooked)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.primaryColor
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 14,
                                        color: theme.primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        s.booked,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$start - $end',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (slot != timeSlots.last)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.screenPadding / 2,
                    ),
                    child: Divider(height: 1, color: theme.dividerColor),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({
    required this.isLoading,
    required this.hasEntity,
    required this.entity,
    required this.initialData,
    required this.spacing,
    required this.isCollectorView,
    required this.s,
  });

  final bool isLoading;
  final bool hasEntity;
  final ScrapPostEntity? entity;
  final Map<String, dynamic> initialData;
  final AppSpacing spacing;
  final bool isCollectorView;
  final S s;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: [
          const _SkeletonBox(width: double.infinity, height: 64, radius: 12),
          SizedBox(height: spacing.screenPadding / 2),
          const _SkeletonBox(width: double.infinity, height: 64, radius: 12),
        ],
      );
    }

    if (hasEntity) {
      return Column(
        children: entity!.scrapPostDetails.asMap().entries.map((entry) {
          // final index = entry.key;
          final detail = entry.value;
          final itemStatus = PostDetailStatus.parseStatus(
            detail.status ?? 'available',
          );
          return Column(
            children: [
              _SectionCard(
                spacing: spacing,
                child: PostItemNoAction(
                  context: context,
                  category: detail.scrapCategory?.categoryName ?? s.unknown,
                  packageInformation: detail.amountDescription,
                  imageUrl: detail.imageUrl,
                  status: itemStatus,
                  isCollectorView: isCollectorView,
                  type: detail.type,
                ),
              ),
            ],
          );
        }).toList(),
      );
    }

    final initialItems = initialData['scrapItems'] as List<dynamic>? ?? [];
    return Column(
      children: initialItems.asMap().entries.map((entry) {
        // final index = entry.key;
        final item = entry.value;
        final map = item as Map<String, dynamic>;
        final itemStatus = PostDetailStatus.parseStatus(
          map['status'] ?? 'available',
        );
        return Column(
          children: [
            _SectionCard(
              spacing: spacing,
              child: PostItemNoAction(
                context: context,
                category: map['category'] ?? '',
                packageInformation: map['amountDescription'] ?? '',
                imageUrl: map['imageUrl'] ?? '',
                status: itemStatus,
                isCollectorView: isCollectorView,
                type: map['type'] as String?,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
