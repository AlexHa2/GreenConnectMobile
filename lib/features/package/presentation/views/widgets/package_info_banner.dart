import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: space, vertical: space * 0.75),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: AppColors.info),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Dùng điểm để nhận ưu đãi và mua các gói dịch vụ!',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
