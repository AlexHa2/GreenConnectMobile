import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/create_offer/create_offer_header.dart';
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

class CreateSupplementaryOfferBottomSheet extends ConsumerStatefulWidget {
  final ScrapPostEntity post;

  const CreateSupplementaryOfferBottomSheet({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<CreateSupplementaryOfferBottomSheet> createState() =>
      _CreateSupplementaryOfferBottomSheetState();
}

class _CreateSupplementaryOfferBottomSheetState
    extends ConsumerState<CreateSupplementaryOfferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, OfferItemData> _offerItems = {};
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
          final detailType = ScrapPostDetailType.parseType(detail.type);
          // For donation, set price to 0 and keep it fixed
          final initialPrice = detailType == ScrapPostDetailType.donation
              ? 0.0
              : 0.0; // Both start at 0, but donation stays at 0

          _offerItems[detail.scrapCategory!.scrapCategoryId] = OfferItemData(
            categoryId: detail.scrapCategory!.scrapCategoryId,
            categoryName: detail.scrapCategory!.categoryName,
            totalPrice: initialPrice,
            unit: 'kg',
            isSelected: true,
          );
        }
      }
    }
  }

  void _toggleItem(String categoryId, String categoryName) {
    if (widget.post.mustTakeAll == true) {
      return;
    } // Can't toggle if must take all

    setState(() {
      if (_offerItems.containsKey(categoryId)) {
        _offerItems.remove(categoryId);
      } else {
        // Find the detail to get its type
        final detail = widget.post.scrapPostDetails.firstWhere(
          (d) => d.scrapCategory?.scrapCategoryId == categoryId,
          orElse: () => widget.post.scrapPostDetails.first,
        );
        final detailType = ScrapPostDetailType.parseType(detail.type);

        // For donation, set price to 0 and keep it fixed
        final initialPrice = detailType == ScrapPostDetailType.donation
            ? 0.0
            : 0.0; // Both start at 0, but donation stays at 0

        _offerItems[categoryId] = OfferItemData(
          categoryId: categoryId,
          categoryName: categoryName,
          totalPrice: initialPrice,
          unit: 'kg',
          isSelected: true,
        );
      }
    });
  }

  Future<void> _submitSupplementaryOffer() async {
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

    // Validate prices for SALE and SERVICE items
    for (var item in _offerItems.values) {
      final detail = widget.post.scrapPostDetails.firstWhere(
        (d) => d.scrapCategory?.scrapCategoryId == item.categoryId,
        orElse: () => widget.post.scrapPostDetails.first,
      );
      final detailType = ScrapPostDetailType.parseType(detail.type);

      // SALE and SERVICE must have price > 0
      if ((detailType == ScrapPostDetailType.sale ||
              detailType == ScrapPostDetailType.service) &&
          item.totalPrice <= 0) {
        CustomToast.show(
          context,
          S.of(context)!.please_enter_price,
          type: ToastType.error,
        );
        return;
      }
    }

    // Set submitting flag
    setState(() {
      _isSubmitting = true;
    });

    final offerDetails = _offerItems.values
        .map(
          (item) {
            // Find the detail type for this item
            final detail = widget.post.scrapPostDetails.firstWhere(
              (d) => d.scrapCategory?.scrapCategoryId == item.categoryId,
              orElse: () => widget.post.scrapPostDetails.first,
            );
            final detailType = ScrapPostDetailType.parseType(detail.type);

            // For donation, always set price to 0
            final price = detailType == ScrapPostDetailType.donation
                ? 0.0
                : item.totalPrice;

            return OfferDetailRequest(
              scrapCategoryId: item.categoryId,
              pricePerUnit: price,
              unit: item.unit,
            );
          },
        )
        .toList();

    final request = CreateOfferRequestEntity(
      offerDetails: offerDetails,
    );

    final success = await ref
        .read(offerViewModelProvider.notifier)
        .createSupplementaryOffer(
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
          S.of(context)!.transaction_created_successfully,
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

          // Info banner
          Container(
            margin: EdgeInsets.all(space),
            padding: EdgeInsets.all(space),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(space),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: space * 0.5),
                Expanded(
                  child: Text(
                    s.supplementary_offer_note,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

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
                    final detailType = ScrapPostDetailType.parseType(detail.type);

                    return OfferItemCard(
                      categoryName: categoryName,
                      amountDescription: detail.amountDescription,
                      imageUrl: detail.imageUrl,
                      isSelected: isSelected,
                      canToggle: canToggle,
                      totalPrice: _offerItems[categoryId]?.totalPrice ?? 0.0,
                      unit: _offerItems[categoryId]?.unit ?? 'kg',
                      detailType: detailType,
                      onToggle: () => _toggleItem(categoryId, categoryName),
                      onPriceChanged: (price) {
                        setState(() {
                          if (_offerItems.containsKey(categoryId)) {
                            // For donation, always keep price at 0
                            if (detailType == ScrapPostDetailType.donation) {
                              _offerItems[categoryId]!.totalPrice = 0.0;
                            } else {
                              _offerItems[categoryId]!.totalPrice = price;
                            }
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

                  SizedBox(height: space * 2),
                ],
              ),
            ),
          ),

          // Submit button
          OfferSubmitButton(
            isProcessing: isProcessing || _isSubmitting,
            onSubmit: _submitSupplementaryOffer,
          ),
        ],
      ),
    );
  }
}

