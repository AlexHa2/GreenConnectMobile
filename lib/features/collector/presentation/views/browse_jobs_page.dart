import 'package:GreenConnectMobile/features/collector/presentation/views/widgets/job_item_card.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BrowseJobsPage extends StatefulWidget {
  const BrowseJobsPage({super.key});

  @override
  State<BrowseJobsPage> createState() => _BrowseJobsPageState();
}

class _BrowseJobsPageState extends State<BrowseJobsPage> {
  bool _isMapView = false;

  final List<Map<String, dynamic>> _jobs = [
    {
      'title': 'Plastics Bottles Collection',
      'address': '123 Green st',
      'distance': '0.8 km',
      'points': 120,
      'category': 'Plastics',
      'categoryColor': const Color(0xFF4A90E2),
    },
    {
      'title': 'Mental Scrap Pickup',
      'address': '456 Eco Ave',
      'distance': '1.2 km',
      'points': 250,
      'category': 'Mental',
      'categoryColor': const Color(0xFF9B9B9B),
    },
    {
      'title': 'E-Waste Collection',
      'address': '654 Tech Lane',
      'distance': '3.2 km',
      'points': 300,
      'category': 'Electronics',
      'categoryColor': const Color(0xFF4A90E2),
    },
    {
      'title': 'E-Waste Collection',
      'address': '654 Tech Lane',
      'distance': '3.2 km',
      'points': 300,
      'category': 'Electronics',
      'categoryColor': const Color(0xFF4A90E2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context)!.browse_jobs,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColorDark,
              ),
            ),
            Text(
              '${_jobs.length} ${S.of(context)!.available.toLowerCase()}',
              style: textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Open filter/settings
            },
            icon: Icon(
              Icons.tune,
              color: theme.primaryColorDark,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle Map/List View
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: spacing.screenPadding * 2,
              vertical: spacing.screenPadding,
            ),
            padding: EdgeInsets.all(spacing.screenPadding / 3),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(spacing.screenPadding),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildViewToggle(
                    context,
                    label: S.of(context)!.map,
                    icon: Icons.map_outlined,
                    isSelected: _isMapView,
                    onTap: () {
                      setState(() => _isMapView = true);
                    },
                  ),
                ),
                SizedBox(width: spacing.screenPadding / 2),
                Expanded(
                  child: _buildViewToggle(
                    context,
                    label: S.of(context)!.list,
                    icon: Icons.list,
                    isSelected: !_isMapView,
                    onTap: () {
                      setState(() => _isMapView = false);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(spacing.screenPadding / 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: spacing.screenPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F5F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.screenPadding / 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? theme.primaryColorDark
                  : theme.textTheme.bodyMedium?.color,
            ),
            SizedBox(width: spacing.screenPadding / 2),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.primaryColorDark
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.screenPadding * 2,
        vertical: spacing.screenPadding,
      ),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return Padding(
          padding: EdgeInsets.only(bottom: spacing.screenPadding * 1.5),
          child: JobItemCard(
            title: job['title'],
            address: job['address'],
            distance: job['distance'],
            points: job['points'],
            category: job['category'],
            categoryColor: job['categoryColor'],
            onTap: () {
              context.push(
                '/collection-request-detail',
                extra: job,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMapView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Map view coming soon',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
          ),
        ],
      ),
    );
  }
}

