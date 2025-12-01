import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer/create_offer_header.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer/date_time_picker_field.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer/must_take_all_warning.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer/offer_item_card.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer/offer_item_data.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer/offer_submit_button.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferBottomSheet extends ConsumerStatefulWidget {
  final ScrapPostEntity post;

  const CreateOfferBottomSheet({super.key, required this.post});

  @override
  ConsumerState<CreateOfferBottomSheet> createState() =>
      _CreateOfferBottomSheetState();
}

class _CreateOfferBottomSheetState
    extends ConsumerState<CreateOfferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<int, OfferItemData> _offerItems = {};
  DateTime? _proposedTime;
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize offer items based on mustTakeAll
    if (widget.post.mustTakeAll == true) {
      // Must take all items (only available ones)
      for (var detail in widget.post.scrapPostDetails) {
        // Only include items with available status
        final itemStatus = PostDetailStatus.parseStatus(
          detail.status ?? 'available',
        );
        if (itemStatus == PostDetailStatus.available &&
            detail.scrapCategory?.scrapCategoryId != null) {
          _offerItems[detail.scrapCategory!.scrapCategoryId] = OfferItemData(
            categoryId: detail.scrapCategory!.scrapCategoryId,
            categoryName: detail.scrapCategory!.categoryName,
            totalPrice: 0.0,
            unit: 'kg',
            isSelected: true,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _toggleItem(int categoryId, String categoryName) {
    if (widget.post.mustTakeAll == true) {
      return;
    } // Can't toggle if must take all

    setState(() {
      if (_offerItems.containsKey(categoryId)) {
        _offerItems.remove(categoryId);
      } else {
        _offerItems[categoryId] = OfferItemData(
          categoryId: categoryId,
          categoryName: categoryName,
          totalPrice: 0.0,
          unit: 'kg',
          isSelected: true,
        );
      }
    });
  }

  Future<void> _pickDateTime() async {
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

  Future<void> _submitOffer() async {
    // Prevent double submission
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) return;

    if (_offerItems.isEmpty) {
      CustomToast.show(
        context,
        S.of(context)!.please_select_at_least_one_item,
        type: ToastType.error,
      );
      return;
    }

    if (_proposedTime == null) {
      CustomToast.show(
        context,
        S.of(context)!.please_select_proposed_time,
        type: ToastType.error,
      );
      return;
    }

    // Set submitting flag
    setState(() {
      _isSubmitting = true;
    });

    final offerDetails = _offerItems.values
        .map(
          (item) => OfferDetailRequest(
            scrapCategoryId: item.categoryId,
            pricePerUnit: item.totalPrice,
            unit: item.unit,
          ),
        )
        .toList();

    final request = CreateOfferRequestEntity(
      offerDetails: offerDetails,
      scheduleProposal: ScheduleProposalRequest(
        proposedTime: _proposedTime!,
        responseMessage: _messageController.text.trim(),
      ),
    );

    final success = await ref
        .read(offerViewModelProvider.notifier)
        .createOffer(
          postId: widget.post.scrapPostId.toString(),
          request: request,
        );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        CustomToast.show(
          context,
          S.of(context)!.offer_created_successfully,
          type: ToastType.success,
        );
        Navigator.pop(context, true);
      } else {
        final error = ref.read(offerViewModelProvider).errorMessage;
        CustomToast.show(
          context,
          error ?? S.of(context)!.error_occurred,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final isProcessing = ref.watch(offerViewModelProvider).isProcessing;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(space * 1.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: space),
            width: space * 3,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          CreateOfferHeader(
            postTitle: widget.post.title,
            onClose: () => Navigator.pop(context),
          ),

          const Divider(height: 1),

          // Content
          Flexible(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(space),
                shrinkWrap: true,
                children: [
                  // Must take all warning
                  if (widget.post.mustTakeAll == true)
                    const MustTakeAllWarning(),

                  // Items section
                  Text(
                    s.select_items,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: space * 0.75),

                  ...widget.post.scrapPostDetails.map((detail) {
                    // Only show items with available status
                    final itemStatus = PostDetailStatus.parseStatus(
                      detail.status ?? 'available',
                    );
                    if (itemStatus != PostDetailStatus.available) {
                      return const SizedBox.shrink();
                    }

                    final categoryId = detail.scrapCategory?.scrapCategoryId;
                    final categoryName =
                        detail.scrapCategory?.categoryName ?? s.unknown;

                    if (categoryId == null) return const SizedBox.shrink();

                    final isSelected = _offerItems.containsKey(categoryId);
                    final canToggle = widget.post.mustTakeAll != true;

                    return OfferItemCard(
                      categoryName: categoryName,
                      amountDescription: detail.amountDescription,
                      imageUrl: detail.imageUrl,
                      isSelected: isSelected,
                      canToggle: canToggle,
                      totalPrice: _offerItems[categoryId]?.totalPrice ?? 0.0,
                      unit: _offerItems[categoryId]?.unit ?? 'kg',
                      onToggle: () => _toggleItem(categoryId, categoryName),
                      onPriceChanged: (price) {
                        setState(() {
                          if (_offerItems.containsKey(categoryId)) {
                            _offerItems[categoryId]!.totalPrice = price;
                          }
                        });
                      },
                      onUnitChanged: (newUnit) {
                        setState(() {
                          if (_offerItems.containsKey(categoryId)) {
                            _offerItems[categoryId]!.unit = newUnit;
                          }
                        });
                      },
                    );
                  }),

                  SizedBox(height: space * 1.5),

                  // Proposed time
                  Text(
                    s.proposed_pickup_time,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: space * 0.75),

                  DateTimePickerField(
                    selectedDateTime: _proposedTime,
                    onTap: _pickDateTime,
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
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: s.enter_your_message,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(space),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return s.message_is_required;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: space * 2),
                ],
              ),
            ),
          ),

          // Submit button
          OfferSubmitButton(
            isProcessing: isProcessing || _isSubmitting,
            onSubmit: _submitOffer,
          ),
        ],
      ),
    );
  }
}


