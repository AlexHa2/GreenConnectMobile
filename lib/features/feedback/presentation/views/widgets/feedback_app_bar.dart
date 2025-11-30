import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Gradient AppBar for feedback pages
class FeedbackAppBar extends StatelessWidget {
  final String title;
  final IconData iconData;

  const FeedbackAppBar({
    super.key,
    required this.title,
    this.iconData = Icons.star_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: theme.primaryColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: theme.scaffoldBackgroundColor,
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: TextStyle(
            color: theme.scaffoldBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                theme.primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    iconData,
                    size: 200,
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
