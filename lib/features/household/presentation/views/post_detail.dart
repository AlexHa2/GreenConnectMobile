import 'package:GreenConnectMobile/features/household/presentation/views/widges/card_field_only.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/delete_post_dialog.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/post_item_no_action.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> initialData;

  const PostDetailsScreen({super.key, required this.initialData});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final spacing = theme.extension<AppSpacing>()!;

    final title = initialData['title'] ?? '';
    final description = initialData['description'] ?? '';
    final postedDate = initialData['postedDate'] ?? '';
    final status = (initialData['status'] ?? 'available')
        .toString()
        .toLowerCase();
    final pickupTime = initialData['pickupTime'] ?? '';
    final pickupAddress = initialData['pickupAddress'] ?? '';
    final scrapItems = (initialData['scrapItems'] ?? []) as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text("${s.post} ${s.detail}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              context.pushNamed(
                'update-post',
                extra: {
                  'title': title,
                  'description': description,
                  'pickupAddress': pickupAddress,
                  'pickupTime': pickupTime,
                  'scrapItems': scrapItems,
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
                    // TODO: Xử lý xóa bài viết
                    Navigator.pop(context);
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
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.screenPadding / 2),

          Text(description, style: textTheme.bodyMedium),
          SizedBox(height: spacing.screenPadding),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${s.posted}: $postedDate', style: textTheme.bodyLarge),
              Chip(
                label: Text(
                  s.translateStatus(status),
                  style: textTheme.labelLarge?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: _getStatusColor(status),
                padding: EdgeInsets.all(spacing.screenPadding / 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.screenPadding * 2),

          if (status == 'accepted') ...[
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: spacing.screenPadding * 2,
              ),
              child: GradientButton(
                onPressed: () {
                  // TODO: Mở chi tiết giao dịch
                },
                text: s.transaction_detail,
                icon: Icon(
                  Icons.receipt_long_rounded,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
            SizedBox(height: spacing.screenPadding * 2),
          ],

          CardFieldOnly(
            context: context,
            icon: Icons.schedule_outlined,
            title: s.pickup_time,
            subtitle: pickupTime,
            space: spacing.screenPadding,
          ),
          SizedBox(height: spacing.screenPadding),
          CardFieldOnly(
            context: context,
            icon: Icons.location_on_outlined,
            title: s.pickup_address,
            subtitle: pickupAddress,
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

          ...scrapItems.map((item) {
            final map = item as Map<String, dynamic>;
            return PostItemNoAction(
              context: context,
              category: map['category'] ?? '',
              quantity: map['quantity'] ?? 0,
              weight: (map['weight'] ?? 0).toDouble(),
            );
          }).toList(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () {
          // TODO: Mở chat/message
        },

        child: const Icon(Icons.message_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.warning;
      case 'unavailable':
        return AppColors.warning;
      case 'completed':
        return AppColors.primary;
      case 'accepted':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}

extension StatusLocalization on S {
  String translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return available;
      case 'unavailable':
        return rejected;
      case 'completed':
        return completed;
      case 'accepted':
        return accepted;
      default:
        return status;
    }
  }
}
