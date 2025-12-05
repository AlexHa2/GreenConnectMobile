import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardItemDetailPage extends ConsumerStatefulWidget {
  final int rewardItemId;

  const RewardItemDetailPage({super.key, required this.rewardItemId});

  @override
  ConsumerState<RewardItemDetailPage> createState() =>
      _RewardItemDetailPageState();
}

class _RewardItemDetailPageState extends ConsumerState<RewardItemDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clear selected reward item when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = '';
    return Scaffold(
      appBar: AppBar(title: const Text('Reward Item Details')),
      body: _buildBody(state,theme),
    );
  }

  Widget _buildBody(dynamic state, theme) {
    if (state.isLoading && state.selectedRewardItem == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.selectedRewardItem == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              state.errorMessage!,
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {

              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.selectedRewardItem == null) {
      return Center(
        child: Text(
          'Reward item not found',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    final item = state.selectedRewardItem!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image/icon
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.card_giftcard,
                  size: 100,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Item name
            Text(
              item.itemName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Description section
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Points cost card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200, width: 2),
              ),
              child: Column(
                children: [
                  Icon(Icons.stars, size: 48, color: Colors.amber.shade700),
                  const SizedBox(height: 8),
                  Text(
                    '${item.pointsCost} Points',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Required to redeem',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Item ID (for debugging/reference)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.tag, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Item ID: ${item.rewardItemId}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Redeem button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement redeem functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Redeem functionality coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.redeem),
                label: const Text(
                  'Redeem Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
