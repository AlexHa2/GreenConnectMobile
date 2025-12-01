import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  final Map<int, _OfferItemData> _offerItems = {};
  DateTime? _proposedTime;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize offer items based on mustTakeAll
    if (widget.post.mustTakeAll == true) {
      // Must take all items
      for (var detail in widget.post.scrapPostDetails) {
        if (detail.scrapCategory?.scrapCategoryId != null) {
          _offerItems[detail.scrapCategory!.scrapCategoryId] = _OfferItemData(
            categoryId: detail.scrapCategory!.scrapCategoryId,
            categoryName: detail.scrapCategory!.categoryName,
            pricePerUnit: 0.0,
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
    if (widget.post.mustTakeAll == true)
      return; // Can't toggle if must take all

    setState(() {
      if (_offerItems.containsKey(categoryId)) {
        _offerItems.remove(categoryId);
      } else {
        _offerItems[categoryId] = _OfferItemData(
          categoryId: categoryId,
          categoryName: categoryName,
          pricePerUnit: 0.0,
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

    final offerDetails = _offerItems.values
        .map(
          (item) => OfferDetailRequest(
            scrapCategoryId: item.categoryId,
            pricePerUnit: item.pricePerUnit,
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
          Padding(
            padding: EdgeInsets.all(space),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(space * 0.5),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(space * 0.75),
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: space),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.create_offer,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.post.title,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
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
                    Container(
                      padding: EdgeInsets.all(space),
                      margin: EdgeInsets.only(bottom: space),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(space),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: space * 0.75),
                          Expanded(
                            child: Text(
                              s.must_take_all_items,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Items section
                  Text(
                    s.select_items,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: space * 0.75),

                  ...widget.post.scrapPostDetails.map((detail) {
                    final categoryId = detail.scrapCategory?.scrapCategoryId;
                    final categoryName =
                        detail.scrapCategory?.categoryName ?? s.unknown;

                    if (categoryId == null) return const SizedBox.shrink();

                    final isSelected = _offerItems.containsKey(categoryId);
                    final canToggle = widget.post.mustTakeAll != true;

                    return _ItemCard(
                      categoryName: categoryName,
                      amountDescription: detail.amountDescription,
                      imageUrl: detail.imageUrl,
                      isSelected: isSelected,
                      canToggle: canToggle,
                      pricePerUnit:
                          _offerItems[categoryId]?.pricePerUnit ?? 0.0,
                      unit: _offerItems[categoryId]?.unit ?? 'kg',
                      onToggle: () => _toggleItem(categoryId, categoryName),
                      onPriceChanged: (price) {
                        setState(() {
                          if (_offerItems.containsKey(categoryId)) {
                            _offerItems[categoryId]!.pricePerUnit = price;
                          }
                        });
                      },
                      onUnitChanged: (unit) {
                        setState(() {
                          if (_offerItems.containsKey(categoryId)) {
                            _offerItems[categoryId]!.unit = unit;
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

                  InkWell(
                    onTap: _pickDateTime,
                    borderRadius: BorderRadius.circular(space),
                    child: Container(
                      padding: EdgeInsets.all(space),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor),
                        borderRadius: BorderRadius.circular(space),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: space),
                          Expanded(
                            child: Text(
                              _proposedTime != null
                                  ? DateFormat(
                                      'MMM dd, yyyy - HH:mm',
                                    ).format(_proposedTime!)
                                  : s.select_date_and_time,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _proposedTime != null
                                    ? theme.textTheme.bodyMedium?.color
                                    : theme.hintColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: theme.hintColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: space * 1.5),

                  // Message
                  Text(
                    s.message_optional,
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
                  ),

                  SizedBox(height: space * 2),
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            padding: EdgeInsets.all(space),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isProcessing ? null : _submitOffer,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: space),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(space),
                    ),
                  ),
                  icon: isProcessing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    isProcessing ? s.creating : s.submit_offer,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String categoryName;
  final String amountDescription;
  final String? imageUrl;
  final bool isSelected;
  final bool canToggle;
  final double pricePerUnit;
  final String unit;
  final VoidCallback onToggle;
  final ValueChanged<double> onPriceChanged;
  final ValueChanged<String> onUnitChanged;

  const _ItemCard({
    required this.categoryName,
    required this.amountDescription,
    this.imageUrl,
    required this.isSelected,
    required this.canToggle,
    required this.pricePerUnit,
    required this.unit,
    required this.onToggle,
    required this.onPriceChanged,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Container(
      margin: EdgeInsets.only(bottom: space),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? theme.primaryColor
              : theme.dividerColor.withValues(alpha: 0.5),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(space),
        color: isSelected
            ? theme.primaryColor.withValues(alpha: 0.05)
            : theme.cardColor,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: canToggle ? onToggle : null,
            borderRadius: BorderRadius.circular(space),
            child: Padding(
              padding: EdgeInsets.all(space),
              child: Row(
                children: [
                  if (imageUrl != null && imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(space * 0.5),
                      child: Image.network(
                        imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 60,
                          height: 60,
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.image_not_supported,
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(space * 0.5),
                      ),
                      child: Icon(
                        Icons.recycling_rounded,
                        color: theme.primaryColor,
                      ),
                    ),
                  SizedBox(width: space),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: space * 0.25),
                        Text(
                          amountDescription,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (canToggle)
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onToggle(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  else
                    Icon(Icons.check_circle_rounded, color: theme.primaryColor),
                ],
              ),
            ),
          ),
          if (isSelected) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(space),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: pricePerUnit.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: S.of(context)!.price_per_unit,
                        prefixText: '${S.of(context)!.per_unit} ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(space * 0.75),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: space,
                          vertical: space * 0.75,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context)!.please_enter_price;
                        }
                        if (double.tryParse(value) == null) {
                          return S.of(context)!.invalid_price;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final price = double.tryParse(value) ?? 0.0;
                        onPriceChanged(price);
                      },
                    ),
                  ),
                  SizedBox(width: space),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: unit,
                      decoration: InputDecoration(
                        labelText: S.of(context)!.unit,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(space * 0.75),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: space,
                          vertical: space * 0.75,
                        ),
                      ),
                      items: ['kg', 'g', 'ton', 'piece']
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) onUnitChanged(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OfferItemData {
  final int categoryId;
  final String categoryName;
  double pricePerUnit;
  String unit;
  bool isSelected;

  _OfferItemData({
    required this.categoryId,
    required this.categoryName,
    required this.pricePerUnit,
    required this.unit,
    required this.isSelected,
  });
}
