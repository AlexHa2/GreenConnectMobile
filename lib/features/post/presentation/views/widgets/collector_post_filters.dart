import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectorCategorySearch extends StatelessWidget {
  final int? selectedCategoryId;
  final ValueChanged<int?> onChanged;
  const CollectorCategorySearch({super.key, required this.selectedCategoryId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(space, space, space, 0),
      child: Consumer(
        builder: (context, ref, _) {
          final categoryState = ref.watch(scrapCategoryViewModelProvider);
          final categories = categoryState.listData?.data ?? [];
          return Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(space),
            child: DropdownButtonFormField<int>(
              initialValue: selectedCategoryId,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: s.search,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(space),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: space,
                  vertical: space * 0.9,
                ),
              ),
              items: [
                DropdownMenuItem<int>(value: null, child: Text(s.search)),
                ...categories.map(
                  (cat) => DropdownMenuItem<int>(
                    value: cat.scrapCategoryId,
                    child: Text(cat.categoryName),
                  ),
                ),
              ],
              onChanged: onChanged,
            ),
          );
        },
      ),
    );
  }
}

class CollectorSortSection extends StatelessWidget {
  final bool sortByLocation;
  final bool sortByCreateAt;
  final VoidCallback onSortByLocation;
  final VoidCallback onSortByCreateAt;
  const CollectorSortSection({super.key, required this.sortByLocation, required this.sortByCreateAt, required this.onSortByLocation, required this.onSortByCreateAt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space),
      child: Row(
        children: [
          CollectorSortPill(
            label: s.sort_by_location,
            icon: Icons.location_on_outlined,
            isActive: sortByLocation,
            onTap: onSortByLocation,
          ),
          SizedBox(width: space * 0.5),
          CollectorSortPill(
            label: s.sort_by_date,
            icon: Icons.schedule,
            isActive: sortByCreateAt,
            onTap: onSortByCreateAt,
          ),
        ],
      ),
    );
  }
}

class CollectorSortPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  const CollectorSortPill({super.key, required this.label, required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: space, vertical: space / 2),
        decoration: BoxDecoration(
          color: isActive
              ? theme.primaryColor.withValues(alpha: 0.15)
              : theme.disabledColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? theme.primaryColor : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? theme.primaryColor : theme.canvasColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? theme.primaryColor : theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
