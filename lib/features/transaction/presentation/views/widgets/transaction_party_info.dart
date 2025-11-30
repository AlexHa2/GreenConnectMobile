import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class TransactionPartyInfo extends StatelessWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final ThemeData theme;
  final double space;
  final S s;

  const TransactionPartyInfo({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.theme,
    required this.space,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowCollector = userRole != Role.individualCollector && userRole != Role.businessCollector;
    final party = shouldShowCollector
        ? transaction.scrapCollector
        : transaction.household;

    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space / 2),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                shouldShowCollector ? Icons.person_outline : Icons.home_outlined,
                color: theme.primaryColor,
                size: space * 2,
              ),
              SizedBox(width: space),
              Text(
                shouldShowCollector ? s.collector_info : s.household_info,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          SizedBox(height: space),
          Divider(height: 1, color: theme.dividerColor),
          SizedBox(height: space),
          
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: space * 2.5,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                backgroundImage: party.avatarUrl != null
                    ? NetworkImage(party.avatarUrl!)
                    : null,
                child: party.avatarUrl == null
                    ? Icon(
                        shouldShowCollector ? Icons.person : Icons.home,
                        size: space * 2.5,
                        color: theme.primaryColor,
                      )
                    : null,
              ),
              
              SizedBox(width: space),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.fullName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: space / 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: space * 1.2,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: space / 2),
                        Text(
                          party.phoneNumber,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Address if available
          if (transaction.offer?.scrapPost?.address != null) ...[
            SizedBox(height: space),
            Container(
              padding: EdgeInsets.all(space),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(space / 2),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: space * 1.5,
                    color: theme.primaryColor,
                  ),
                  SizedBox(width: space),
                  Expanded(
                    child: Text(
                      transaction.offer!.scrapPost!.address,
                      style: theme.textTheme.bodySmall,
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
