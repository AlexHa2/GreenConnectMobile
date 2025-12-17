import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class PackageFilterSheet extends StatefulWidget {
  final String? currentPackageType;
  final bool? currentSortByPrice;
  final Function({
    String? packageType,
    bool? sortByPrice,
  }) onFilterApplied;

  const PackageFilterSheet({
    super.key,
    this.currentPackageType,
    this.currentSortByPrice,
    required this.onFilterApplied,
  });

  @override
  State<PackageFilterSheet> createState() => _PackageFilterSheetState();
}

class _PackageFilterSheetState extends State<PackageFilterSheet> {
  String? _selectedPackageType;
  bool? _selectedSortByPrice;

  @override
  void initState() {
    super.initState();
    _selectedPackageType = widget.currentPackageType;
    _selectedSortByPrice = widget.currentSortByPrice;
  }

  void _applyFilters() {
    widget.onFilterApplied(
      packageType: _selectedPackageType,
      sortByPrice: _selectedSortByPrice,
    );
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _selectedPackageType = null;
      _selectedSortByPrice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(space * 1.5),
          topRight: Radius.circular(space * 1.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: space),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(space * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.filter_packages,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    child: Text(s.cancel),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: theme.dividerColor),

            // Filter options
            Padding(
              padding: EdgeInsets.all(space * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package Type Filter
                  Text(
                    s.package_type,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: space),
                  Wrap(
                    spacing: space,
                    runSpacing: space * 0.5,
                    children: [
                      _buildFilterChip(
                        label: s.all_packages,
                        selected: _selectedPackageType == null,
                        onTap: () => setState(() => _selectedPackageType = null),
                        theme: theme,
                        space: space,
                      ),
                      _buildFilterChip(
                        label: s.freemium_packages,
                        selected: _selectedPackageType == s.freemium_packages,
                        onTap: () =>
                            setState(() => _selectedPackageType = s.freemium_packages),
                        theme: theme,
                        space: space,
                      ),
                      _buildFilterChip(
                        label: s.paid_packages,
                        selected: _selectedPackageType == s.paid_packages,
                        onTap: () => setState(() => _selectedPackageType = s.paid_packages),
                        theme: theme,
                        space: space,
                      ),
                    ],
                  ),

                  SizedBox(height: space * 2),

                  // Sort By Price
                  Text(
                    s.sort_by_price,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: space),
                  Wrap(
                    spacing: space,
                    runSpacing: space * 0.5,
                    children: [
                      _buildFilterChip(
                        label: s.price_low_to_high,
                        selected: _selectedSortByPrice == true,
                        onTap: () => setState(() => _selectedSortByPrice = true),
                        theme: theme,
                        space: space,
                      ),
                      _buildFilterChip(
                        label: s.price_high_to_low,
                        selected: _selectedSortByPrice == false,
                        onTap: () => setState(() => _selectedSortByPrice = false),
                        theme: theme,
                        space: space,
                      ),
                    ],
                  ),

                  SizedBox(height: space * 2),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: space),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(space),
                        ),
                      ),
                      child: Text(
                        s.search,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required ThemeData theme,
    required double space,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(space * 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: space * 1.2,
          vertical: space * 0.7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(space * 2),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
