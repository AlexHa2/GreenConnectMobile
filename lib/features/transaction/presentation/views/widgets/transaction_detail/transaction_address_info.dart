import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class TransactionAddressInfo extends StatelessWidget {
  final String? address;
  final ThemeData theme;
  final double space;

  const TransactionAddressInfo({
    super.key,
    required this.address,
    required this.theme,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    if (address == null || address!.isEmpty) {
      return const SizedBox.shrink();
    }
    final s = S.of(context)!;
    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space / 2),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: theme.primaryColor,
                size: space * 2,
              ),
              SizedBox(width: space),
              Text(
                s.pickup_address,
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
              Icon(
                Icons.location_on,
                size: space * 1.5,
                color: theme.primaryColor,
              ),
              SizedBox(width: space),
              Expanded(
                child: Text(
                  address!,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
