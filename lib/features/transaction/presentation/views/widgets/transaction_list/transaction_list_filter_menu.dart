import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Filter menu modal bottom sheet
class TransactionListFilterMenu {
  static Future<void> show({
    required BuildContext context,
    required String currentFilterType,
    required bool currentIsDescending,
    required Function(String filterType, bool isDescending) onFilterChanged,
  }) async {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterMenuContent(
        currentFilterType: currentFilterType,
        currentIsDescending: currentIsDescending,
        onFilterChanged: onFilterChanged,
        space: space,
        s: s,
      ),
    );
  }
}

/// Filter menu content widget
class _FilterMenuContent extends StatefulWidget {
  final String currentFilterType;
  final bool currentIsDescending;
  final Function(String filterType, bool isDescending) onFilterChanged;
  final double space;
  final S s;

  const _FilterMenuContent({
    required this.currentFilterType,
    required this.currentIsDescending,
    required this.onFilterChanged,
    required this.space,
    required this.s,
  });

  @override
  State<_FilterMenuContent> createState() => _FilterMenuContentState();
}

class _FilterMenuContentState extends State<_FilterMenuContent> {
  late String _selectedFilterType;
  late bool _selectedIsDescending;

  @override
  void initState() {
    super.initState();
    _selectedFilterType = widget.currentFilterType;
    _selectedIsDescending = widget.currentIsDescending;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.space * 2),
          topRight: Radius.circular(widget.space * 2),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: widget.space),
              width: widget.space * 4,
              height: widget.space * 0.5,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(widget.space * 0.25),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.all(widget.space * 2),
              child: Text(
                widget.s.sort_by,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Sort by section
            _FilterSection(
              title: widget.s.sort_by,
              children: [
                _FilterOption(
                  icon: Icons.access_time,
                  label: widget.s.transaction_created_time,
                  isSelected: _selectedFilterType == 'createAt',
                  onTap: () {
                    setState(() {
                      _selectedFilterType = 'createAt';
                    });
                  },
                  space: widget.space,
                ),
                _FilterOption(
                  icon: Icons.update,
                  label: widget.s.transaction_updated_time,
                  isSelected: _selectedFilterType == 'updateAt',
                  onTap: () {
                    setState(() {
                      _selectedFilterType = 'updateAt';
                    });
                  },
                  space: widget.space,
                ),
              ],
              space: widget.space,
            ),

            Divider(
              height: widget.space * 2,
              thickness: 1,
              indent: widget.space * 2,
              endIndent: widget.space * 2,
            ),

            // Order section
            _FilterSection(
              title: widget.s.order,
              children: [
                _FilterOption(
                  icon: Icons.arrow_upward,
                  label: widget.s.oldest_first,
                  isSelected: !_selectedIsDescending,
                  onTap: () {
                    setState(() {
                      _selectedIsDescending = false;
                    });
                  },
                  space: widget.space,
                ),
                _FilterOption(
                  icon: Icons.arrow_downward,
                  label: widget.s.newest_first,
                  isSelected: _selectedIsDescending,
                  onTap: () {
                    setState(() {
                      _selectedIsDescending = true;
                    });
                  },
                  space: widget.space,
                ),
              ],
              space: widget.space,
            ),

            // Apply button
            Padding(
              padding: EdgeInsets.all(widget.space * 2),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onFilterChanged(
                      _selectedFilterType,
                      _selectedIsDescending,
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: widget.space * 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.space),
                    ),
                  ),
                  child: Text(
                    widget.s.confirm_details,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter section widget
class _FilterSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double space;

  const _FilterSection({
    required this.title,
    required this.children,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: space * 2,
            vertical: space,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

/// Filter option widget
class _FilterOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double space;

  const _FilterOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: space * 2,
          vertical: space * 1.5,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.primaryColor
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: space * 2,
            ),
            SizedBox(width: space * 1.5),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? theme.primaryColor
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.primaryColor,
                size: space * 2,
              ),
          ],
        ),
      ),
    );
  }
}
