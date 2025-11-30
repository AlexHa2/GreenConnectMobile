import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/info_row_widget.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_section_title.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/status_badge.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CollectorPostDetailPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;

  const CollectorPostDetailPage({super.key, required this.initialData});

  @override
  ConsumerState<CollectorPostDetailPage> createState() =>
      _CollectorPostDetailPageState();
}

class _CollectorPostDetailPageState
    extends ConsumerState<CollectorPostDetailPage> {
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

  void _showCreateOfferDialog() {
    final s = S.of(context)!;
    final postState = ref.read(scrapPostViewModelProvider);
    final entity = postState.detailData;

    if (entity == null || entity.scrapPostDetails.isEmpty) {
      CustomToast.show(context, s.error_occurred, type: ToastType.error);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateOfferBottomSheet(
        postId: scrapPostId,
        postDetails: entity.scrapPostDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final s = S.of(context)!;
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

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

    final canCreateOffer =
        PostStatus.parseStatus(status) == PostStatus.open ||
        PostStatus.parseStatus(status) == PostStatus.partiallyBooked;

    return Scaffold(
      appBar: AppBar(title: Text(s.detail), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(scrapPostViewModelProvider.notifier)
              .fetchDetail(scrapPostId);
        },
        child: ListView(
          padding: EdgeInsets.all(space),
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
            SizedBox(height: space),

            // Title
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: space),

            // Description
            Text(description, style: textTheme.bodyLarge),
            SizedBox(height: space * 1.5),

            // Info Section
            PostSectionTitle(title: s.information),
            SizedBox(height: space * 0.75),
            Card(
              child: Padding(
                padding: EdgeInsets.all(space),
                child: Column(
                  children: [
                    InfoRowWidget(
                      icon: Icons.access_time,
                      label: s.pickup_time,
                      value: pickupTime,
                    ),
                    SizedBox(height: space * 0.75),
                    InfoRowWidget(
                      icon: Icons.location_on,
                      label: s.pickup_address,
                      value: pickupAddress,
                    ),
                    SizedBox(height: space * 0.75),
                    InfoRowWidget(
                      icon: mustTakeAll
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      label: s.must_take_all,
                      value: mustTakeAll ? s.yes : s.no,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: space * 1.5),

            // Items Section
            if (hasEntity && entity.scrapPostDetails.isNotEmpty) ...[
              PostSectionTitle(title: s.items),
              SizedBox(height: space * 0.75),
              ...entity.scrapPostDetails.map(
                (item) => Card(
                  margin: EdgeInsets.only(bottom: space * 0.75),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.recycling, color: theme.primaryColor),
                    ),
                    title: Text(
                      item.scrapCategory!.categoryName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      item.amountDescription,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              SizedBox(height: space),
            ],

            // Create Offer Button
            if (canCreateOffer)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _showCreateOfferDialog,
                  icon: const Icon(Icons.local_offer),
                  label: Text(s.create_offer),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: space),
                    backgroundColor: theme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CreateOfferBottomSheet extends ConsumerStatefulWidget {
  final String postId;
  final List<ScrapPostDetailEntity> postDetails;

  const _CreateOfferBottomSheet({
    required this.postId,
    required this.postDetails,
  });

  @override
  ConsumerState<_CreateOfferBottomSheet> createState() =>
      _CreateOfferBottomSheetState();
}

class _CreateOfferBottomSheetState
    extends ConsumerState<_CreateOfferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> _priceControllers = {};
  final Map<int, String> _unitValues = {};
  final _messageController = TextEditingController();
  DateTime? _proposedTime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    for (var detail in widget.postDetails) {
      _priceControllers[detail.scrapCategory!.scrapCategoryId] =
          TextEditingController();
      _unitValues[detail.scrapCategory!.scrapCategoryId] =
          detail.amountDescription;
    }
  }

  @override
  void dispose() {
    for (var controller in _priceControllers.values) {
      controller.dispose();
    }
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _proposedTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_proposedTime == null) {
      CustomToast.show(
        context,
        S.of(context)!.please_select_time,
        type: ToastType.error,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final offerDetails = <OfferDetailRequest>[];
    for (var detail in widget.postDetails) {
      final categoryId = detail.scrapCategory!.scrapCategoryId;
      final priceText = _priceControllers[categoryId]?.text.trim() ?? '';
      if (priceText.isNotEmpty) {
        final price = double.tryParse(priceText);
        if (price != null && price > 0) {
          offerDetails.add(
            OfferDetailRequest(
              scrapCategoryId: categoryId,
              pricePerUnit: price,
              unit: _unitValues[categoryId] ?? detail.amountDescription,
            ),
          );
        }
      }
    }

    if (offerDetails.isEmpty) {
      setState(() => _isSubmitting = false);
      CustomToast.show(
        context,
        S.of(context)!.please_enter_at_least_one_price,
        type: ToastType.error,
      );
      return;
    }

    final request = CreateOfferRequestEntity(
      offerDetails: offerDetails,
      scheduleProposal: ScheduleProposalRequest(
        proposedTime: _proposedTime!,
        responseMessage: _messageController.text.trim(),
      ),
    );

    final success = await ref
        .read(offerViewModelProvider.notifier)
        .createOffer(postId: widget.postId, request: request);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      CustomToast.show(
        context,
        S.of(context)!.offer_created_successfully,
        type: ToastType.success,
      );
      Navigator.pop(context);
      context.pop();
    } else if (mounted) {
      CustomToast.show(
        context,
        S.of(context)!.failed_to_create_offer,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(space * 1.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: space),
            width: space * 4,
            height: space * 0.4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(space * 0.2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(space * 1.5),
            child: Row(
              children: [
                Icon(Icons.local_offer, color: theme.primaryColor),
                SizedBox(width: space * 0.75),
                Text(
                  s.create_offer,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: theme.dividerColor),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(space * 1.5),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Items prices
                    Text(
                      s.offer_prices,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: space),

                    ...widget.postDetails.map((detail) {
                      final categoryId = detail.scrapCategory!.scrapCategoryId;
                      return Card(
                        margin: EdgeInsets.only(bottom: space),
                        child: Padding(
                          padding: EdgeInsets.all(space),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.scrapCategory!.categoryName,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: space * 0.5),
                              TextFormField(
                                controller: _priceControllers[categoryId],
                                decoration: InputDecoration(
                                  labelText:
                                      '${s.price_per_unit} (${s.per_unit}: ${detail.amountDescription})',
                                  prefixIcon: const Icon(Icons.attach_money),
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null; // Optional
                                  }
                                  final price = double.tryParse(value);
                                  if (price == null || price <= 0) {
                                    return s.invalid_price;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: space),

                    // Proposed time
                    Text(
                      s.proposed_pickup_time,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: space * 0.75),
                    InkWell(
                      onTap: _selectDateTime,
                      child: Container(
                        padding: EdgeInsets.all(space),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(space * 0.75),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: theme.primaryColor,
                            ),
                            SizedBox(width: space),
                            Text(
                              _proposedTime == null
                                  ? s.select_date_time
                                  : '${_proposedTime!.day}/${_proposedTime!.month}/${_proposedTime!.year} ${_proposedTime!.hour}:${_proposedTime!.minute.toString().padLeft(2, '0')}',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: space * 1.5),

                    // Message
                    Text(
                      s.message,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: space * 0.75),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: s.enter_message,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return s.please_enter_message;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: space * 1.5),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: space),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              )
                            : Text(s.submit_offer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
