import 'package:GreenConnectMobile/features/household/presentation/views/widges/post_item.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HouseholdListPostScreen extends StatefulWidget {
  const HouseholdListPostScreen({super.key});

  @override
  State<HouseholdListPostScreen> createState() =>
      _HouseholdListPostScreenState();
}

class _HouseholdListPostScreenState extends State<HouseholdListPostScreen> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> posts = [
    {
      "title": "Plastic Bottles Collection",
      "desc": "HEHEHEHEHEHEHE HEHEHEHEHEHEHE",
      "time": "9 AM - 5 PM",
      "status": "Accepted",
      "color": AppColors.primary,
    },
    {
      "title": "Plastic Bottles Collection",
      "desc": "HEHEHEHEHEHEHE HEHEHEHEHEHEHE",
      "time": "9 AM - 5 PM",
      "status": "Pending",
      "color": AppColors.warning,
    },
    {
      "title": "Plastic Bottles Collection",
      "desc": "HEHEHEHEHEHEHE HEHEHEHEHEHEHE",
      "time": "9 AM - 5 PM",
      "status": "Rejected",
      "color": AppColors.danger,
    },
    {
      "title": "Plastic Bottles Collection",
      "desc": "HEHEHEHEHEHEHE HEHEHEHEHEHEHE",
      "time": "9 AM - 5 PM",
      "status": "Accepted",
      "color": AppColors.primary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    final filteredPosts = selectedFilter == 'All'
        ? posts
        : posts.where((post) => post["status"] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("${s.list} ${s.post}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go("/"),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
        ),
        onPressed: () => context.push("/create-post"),
        backgroundColor: AppColors.primary,
        label: Text(
          s.add,
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.scaffoldBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: s.search_by_name,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),

            // Filter buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton("All", AppColors.primary),
                  SizedBox(width: spacing.screenPadding / 2),
                  _buildFilterButton("Accepted", AppColors.primary),
                  SizedBox(width: spacing.screenPadding / 2),
                  _buildFilterButton("Available", AppColors.warning),
                  SizedBox(width: spacing.screenPadding / 2),
                  _buildFilterButton("Rejected", AppColors.danger),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // List of posts
            Expanded(
              child: ListView.builder(
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: PostItem(
                      title: post["title"],
                      desc: post["desc"],
                      time: post["time"],
                      status: post["status"],
                      color: post["color"],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, Color color) {
    final isSelected = selectedFilter == label;
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: () {
        setState(() => selectedFilter = label);
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? color.withValues(alpha: 0.1)
            : Colors.transparent,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: isSelected ? color : theme.textTheme.bodyMedium!.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
