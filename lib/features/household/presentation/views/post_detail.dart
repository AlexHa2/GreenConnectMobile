import 'package:GreenConnectMobile/features/household/presentation/views/widges/card_field_only.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/delete_post_dialog.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/post_item_no_action.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final spacing = theme.extension<AppSpacing>()!;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: Text("${s.post} ${s.detail}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              context.pushNamed(
                'update-post',
                extra: {
                  'title': 'Recycling Old Phones',
                  'description': 'Collected used phones for recycling',
                  'pickupAddress': '45 Green Avenue',
                  'pickupTime': 'Morning (8:00 AM - 12:00 PM)',
                  'scrapItems': [
                    {
                      'category': 'Electronics',
                      'quantity': 3,
                      'weight': 2.5,
                      'image': null,
                    },
                  ],
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => DeletePostDialog(
                  onDelete: () {
                    // TODO: call API hoặc xóa bài viết
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(spacing.screenPadding),
        children: [
          Text(
            'Plastic Bottles Collection',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.screenPadding / 2),
          Text(
            'Collection of clean plastic bottles ready for recycling. Mostly water and soft drink bottles.',
            style: textTheme.bodyMedium,
          ),
          SizedBox(height: spacing.screenPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${s.posted}: 20/06/2024', style: textTheme.bodyLarge),
              Chip(
                label: Text(
                  s.available,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.warning,
                padding: EdgeInsets.all(spacing.screenPadding / 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.screenPadding),

          CardFieldOnly(
            context: context,
            icon: Icons.schedule_outlined,
            title: s.pickup_time,
            subtitle: 'Morning ( 8:00 AM - 12:00 PM)',
            space: spacing.screenPadding,
          ),
          SizedBox(height: spacing.screenPadding),
          CardFieldOnly(
            context: context,
            icon: Icons.location_on_outlined,
            title: s.pickup_address,
            subtitle: '123 green street, ecosystem',
            space: spacing.screenPadding,
          ),
          SizedBox(height: spacing.screenPadding * 2),

          Text(
            "${s.list} ${s.items}",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: spacing.screenPadding * 1.5,
            ),
          ),
          SizedBox(height: spacing.screenPadding),
          PostItemNoAction(
            context: context,
            category: 'Electronics',
            quantity: 11,
            weight: 1,
          ),
          PostItemNoAction(
            context: context,
            category: 'Electronics',
            quantity: 11,
            weight: 1,
          ),
          PostItemNoAction(
            context: context,
            category: 'Electronics',
            quantity: 11,
            weight: 1,
          ),
          PostItemNoAction(
            context: context,
            category: 'Electronics',
            quantity: 11,
            weight: 1,
          ),
        ],
      ),
    );
  }
}
