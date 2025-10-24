import 'package:flutter/material.dart';

class CardFieldOnly extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String title;
  final String subtitle;
  final double space;

  const CardFieldOnly({
    super.key,
    required this.context,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.space,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin:const EdgeInsets.only(bottom: 0.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(space),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space * 2, vertical: space),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColorDark,
              size: space * 2,
            ),
            SizedBox(width: space),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: space / 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
