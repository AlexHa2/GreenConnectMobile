import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/activity_card.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HouseholdRewardHistory extends ConsumerStatefulWidget {
  const HouseholdRewardHistory({super.key});

  @override
  ConsumerState<HouseholdRewardHistory> createState() =>
      _HouseholdRewardHistoryState();
}

class _HouseholdRewardHistoryState
    extends ConsumerState<HouseholdRewardHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final rewardState = ref.watch(rewardViewModelProvider);

    final isLoading = rewardState.isLoading;
    final hasError = rewardState.errorMessage != null;
    final historyList = rewardState.rewardHistory ?? [];
    final isEmpty = historyList.isEmpty && !isLoading && !hasError;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.transaction_history),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: EdgeInsets.all(space.toDouble()),
          child: Column(
            children: [
              SizedBox(height: space),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.danger,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              rewardState.errorMessage!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _onRefresh,
                              child: Text(s.try_again),
                            ),
                          ],
                        ),
                      )
                    : isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: theme.disabledColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              s.no_transaction_history,
                              
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _onRefresh,
                              child: Text(s.try_again),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          final item = historyList[index];
                          return ActivityCard(historyItem: item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
