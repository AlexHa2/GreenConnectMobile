// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/providers/recurring_schedule_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/empty_state_widget.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecurringSchedulesPage extends ConsumerStatefulWidget {
  const RecurringSchedulesPage({super.key});

  @override
  ConsumerState<RecurringSchedulesPage> createState() =>
      _RecurringSchedulesPageState();
}

class _RecurringSchedulesPageState
    extends ConsumerState<RecurringSchedulesPage> {
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _sortByCreatedAtDesc = true;

  final List<RecurringScheduleEntity> _items = [];

  Future<void> _openCreateBottomSheet() async {
    final ok = await context.push<bool>('/recurring-schedules-new');
    if (ok == true) {
      await _onRefresh();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSchedules(isRefresh: true);
      ref
          .read(scrapCategoryViewModelProvider.notifier)
          .fetchScrapCategories(pageNumber: 1, pageSize: 50);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMore();
    }
  }

  Future<void> _loadSchedules({required bool isRefresh}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _items.clear();
      if (mounted) setState(() {});
    }

    await ref.read(recurringScheduleViewModelProvider.notifier).fetchList(
          page: _currentPage,
          size: _pageSize,
          sortByCreatedAt: _sortByCreatedAtDesc,
        );

    if (!mounted) return;

    final state = ref.read(recurringScheduleViewModelProvider);
    final listData = state.listData;
    if (listData != null) {
      _items.addAll(listData.data);
      _hasMoreData = listData.pagination.nextPage != null;
      setState(() {});
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    final state = ref.read(recurringScheduleViewModelProvider);
    final nextPage = state.listData?.pagination.nextPage;
    if (nextPage == null) {
      setState(() => _hasMoreData = false);
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _currentPage = nextPage;
    });

    await ref.read(recurringScheduleViewModelProvider.notifier).fetchList(
          page: _currentPage,
          size: _pageSize,
          sortByCreatedAt: _sortByCreatedAtDesc,
        );

    if (!mounted) return;

    final newData = ref.read(recurringScheduleViewModelProvider).listData?.data;
    if (newData != null) {
      _items.addAll(newData);
      _hasMoreData =
          ref.read(recurringScheduleViewModelProvider).listData?.pagination
                  .nextPage !=
              null;
    }

    setState(() => _isLoadingMore = false);
  }

  Future<void> _onRefresh() async {
    await _loadSchedules(isRefresh: true);
  }

  String _weekdayLabel(BuildContext context, int dayOfWeek) {
    final locale = S.of(context)!.localeName;

    // Handle both 0-6 and 1-7 formats safely.
    final normalized = dayOfWeek == 0 ? 7 : dayOfWeek;

    // 2020-01-06 is Monday (weekday=1)
    final baseMonday = DateTime(2020, 1, 6);
    final date = baseMonday.add(Duration(days: normalized - 1));
    return DateFormat.EEEE(locale).format(date);
  }

  String _timeLabel(BuildContext context, String raw) {
    // API returns "HH:mm:ss" or "HH:mm:ss.SSSSSSS"; display as HH:mm
    final locale = S.of(context)!.localeName;
    final cleaned = raw.split('.').first;
    final parts = cleaned.split(':');
    if (parts.length < 2) return raw;
    final hh = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    if (hh == null || mm == null) return raw;
    final fake = DateTime(2020, 1, 1, hh, mm);
    return DateFormat.Hm(locale).format(fake);
  }

  String _dateTimeLabel(BuildContext context, DateTime? dt) {
    if (dt == null) return '';
    final locale = S.of(context)!.localeName;
    return DateFormat('dd/MM/yyyy HH:mm', locale).format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final vmState = ref.watch(recurringScheduleViewModelProvider);
    final isFirstLoading = vmState.isLoadingList && _items.isEmpty;
    final error = vmState.errorMessage;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateBottomSheet,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(s.recurring_schedules_create),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/household-home');
                    }
                  },
                  tooltip: s.back,
                ),
                SizedBox(width: spacing * 0.5),
                Container(
                  padding: EdgeInsets.all(spacing * 0.7),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.linearPrimary,
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.recurring_schedules,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.recurring_schedules_description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _sortByCreatedAtDesc = !_sortByCreatedAtDesc;
                    });
                    _loadSchedules(isRefresh: true);
                  },
                  icon: Icon(
                    _sortByCreatedAtDesc
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(
            child: Builder(
              builder: (context) {
                if (isFirstLoading) {
                  return Center(child: RotatingLeafLoader());
                }

                if (error != null && _items.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.error_occurred),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _onRefresh,
                              child: Text(s.retry),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                if (_items.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.18,
                      ),
                      EmptyStateWidget(
                        icon: Icons.event_repeat_outlined,
                        message: s.recurring_schedules_empty_message,
                        actionText: s.recurring_schedules_create,
                        onAction: _openCreateBottomSheet,
                      ),
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: theme.primaryColor,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing),
                    itemCount: _items.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _items.length && _isLoadingMore) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: spacing),
                          child: Center(child: RotatingLeafLoader()),
                        );
                      }

                      final item = _items[index];
                      final weekday = _weekdayLabel(context, item.dayOfWeek);
                      final start = _timeLabel(context, item.startTime);
                      final end = _timeLabel(context, item.endTime);
                      final created = _dateTimeLabel(context, item.createdAt);
                      // final lastRun = _dateTimeLabel(context, item.lastRunDate);

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: spacing),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.6),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(spacing),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.event_repeat_outlined,
                              color: theme.primaryColor,
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 16,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '$weekday · $start - $end',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.address.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          item.address,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (created.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      'Tạo lúc: $created',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          trailing: Switch.adaptive(
                            value: item.isActive,
                            onChanged: (value) async {
                              final ok = await ref
                                  .read(recurringScheduleViewModelProvider
                                      .notifier,)
                                  .toggleSchedule(item.id);

                              if (!context.mounted) return;

                              if (ok) {
                                CustomToast.show(
                                  context,
                                  s.recurring_schedules_toggle_success,
                                  type: ToastType.success,
                                );
                                await _onRefresh();
                              } else {
                                CustomToast.show(
                                  context,
                                  s.recurring_schedules_toggle_failed,
                                  type: ToastType.error,
                                );
                              }
                            },
                          ),
                          onTap: () {
                            context.push('/recurring-schedules/${item.id}');
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
