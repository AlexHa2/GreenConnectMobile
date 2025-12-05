
import 'package:GreenConnectMobile/features/reward_item/presentation/views/reward_item_detail_page.dart';
import 'package:GreenConnectMobile/features/reward_item/presentation/views/widgets/reward_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardItemsPage extends ConsumerStatefulWidget {
  const RewardItemsPage({super.key});

  @override
  ConsumerState<RewardItemsPage> createState() => _RewardItemsPageState();
}

class _RewardItemsPageState extends ConsumerState<RewardItemsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial reward items
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

    // Setup pagination listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {

  }

  void _onSearch(String query) {

  }

  Future<void> _onRefresh() async {

  }

  @override
  Widget build(BuildContext context) {
    final state = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Items'),
        actions: [
          IconButton(
            icon: Icon(
              state == true ? Icons.star : Icons.star_border,
              color: state == true ? Colors.amber : null,
            ),
            onPressed: () {
            },
            tooltip: 'Sort by points',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search reward items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearch,
            ),
          ),

          // Reward items list
          Expanded(child: _buildRewardItemsList(state)),
        ],
      ),
    );
  }

  Widget _buildRewardItemsList(dynamic state) {
    if (state.isLoading && !state.hasRewardItems) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && !state.hasRewardItems) {
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
            ElevatedButton(onPressed: _onRefresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (!state.hasRewardItems) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No reward items found',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount:
            state.rewardItems!.rewardItems.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.rewardItems!.rewardItems.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final rewardItem = state.rewardItems!.rewardItems[index];
          return RewardItemCard(
            rewardItem: rewardItem,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewardItemDetailPage(
                    rewardItemId: rewardItem.rewardItemId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
