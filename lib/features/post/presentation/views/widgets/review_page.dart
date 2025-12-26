import 'package:GreenConnectMobile/core/helper/scrap_post_detail_type_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_item_data.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/time_slot.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/review_item.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/review_section.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/take_all_switch.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({
    super.key,
    required this.title,
    required this.description,
    required this.pickupAddress,
    required this.timeSlots,
    required this.scrapItems,
    required this.isTakeAll,
    required this.onEditStep,
    required this.onTakeAllChanged,
    this.isSubmitting = false,
  });

  final String title;
  final String description;
  final String pickupAddress;
  final List<TimeSlotEntity> timeSlots;
  final List<ScrapItemData> scrapItems;
  final bool isTakeAll;
  final ValueChanged<int> onEditStep;
  final ValueChanged<bool> onTakeAllChanged;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          "${s.post} ${s.information}",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing.screenPadding * 1.5),

        // Info section
        ReviewSection(
          icon: Icons.edit_note,
          title: s.information,
          onEdit: () => onEditStep(0),
          isSubmitting: isSubmitting,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReviewItem(
                label: s.post_title,
                value: title,
              ),
              SizedBox(height: spacing.screenPadding / 2),
              ReviewItem(
                label: s.description,
                value: description,
              ),
              SizedBox(height: spacing.screenPadding / 2),
              ReviewItem(
                label: s.pickup_address,
                value: pickupAddress,
              ),
            ],
          ),
        ),

        SizedBox(height: spacing.screenPadding),

        // Time slots section
        ReviewSection(
          icon: Icons.calendar_month,
          title: s.time_slot_add,
          onEdit: () => onEditStep(1),
          isSubmitting: isSubmitting,
          child: timeSlots.isEmpty
              ? Text(
                  s.no_data,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.time_slot_number.toLowerCase()}: ${timeSlots.length}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: spacing.screenPadding / 2),
                    ...timeSlots.take(3).map(
                          (slot) => Padding(
                            padding: EdgeInsets.only(
                              bottom: spacing.screenPadding / 4,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 16,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: spacing.screenPadding / 2),
                                Expanded(
                                  child: Text(
                                    '${slot.date.day}/${slot.date.month}/${slot.date.year} • ${slot.startTime.format(context)}-${slot.endTime.format(context)}',
                                    style: theme.textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    if (timeSlots.length > 3)
                      Padding(
                        padding:
                            EdgeInsets.only(top: spacing.screenPadding / 4),
                        child: Text(
                          '+ ${timeSlots.length - 3} ${s.make_an_offer}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
        ),

        SizedBox(height: spacing.screenPadding),

        // Items section
        ReviewSection(
          icon: Icons.category_outlined,
          title: s.scrap_item,
          onEdit: () => onEditStep(2),
          isSubmitting: isSubmitting,
          child: scrapItems.isEmpty
              ? Text(
                  s.no_data,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.number_of_items.toLowerCase()}: ${scrapItems.length} ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: spacing.screenPadding / 2),
                    ...scrapItems.take(3).map(
                          (it) => Padding(
                            padding: EdgeInsets.only(
                              bottom: spacing.screenPadding / 4,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: spacing.screenPadding / 2),
                                Expanded(
                                  child: Text(
                                    '${it.categoryName} • ${ScrapPostDetailTypeHelper.getLocalizedType(context, it.type)}',
                                    style: theme.textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    if (scrapItems.length > 3)
                      Padding(
                        padding:
                            EdgeInsets.only(top: spacing.screenPadding / 4),
                        child: Text(
                          '+ ${scrapItems.length - 3} ${s.make_an_offer}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
        ),

        SizedBox(height: spacing.screenPadding),

        // Take all section
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(spacing.screenPadding),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TakeAllSwitch(
                value: isTakeAll,
                onChange: (val) {
                  if (isSubmitting) return;
                  onTakeAllChanged(val);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

