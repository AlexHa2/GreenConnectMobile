import 'package:GreenConnectMobile/core/enum/complaint_status.dart';
import 'package:GreenConnectMobile/core/helper/complaint_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/providers/complaint_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ComplaintListPage extends ConsumerStatefulWidget {
  const ComplaintListPage({super.key});

  @override
  ConsumerState<ComplaintListPage> createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends ConsumerState<ComplaintListPage> {
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  final int _size = 10;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  ComplaintStatus? _selectedStatus;
  bool _sortAscending = false; // false = descending (newest first)

  final List<ComplaintEntity> _complaints = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      _loadMore();
    }
  }

  Future<void> _refresh() async {
    _page = 1;
    _hasMore = true;
    _complaints.clear();

    await ref
        .read(complaintViewModelProvider.notifier)
        .fetchAllComplaints(
          pageNumber: _page,
          pageSize: _size,
          sortByCreatedAt: _sortAscending,
          sortByStatus: _selectedStatus?.label,
        );

    final state = ref.read(complaintViewModelProvider);
    final newItems = state.listData?.data ?? [];
    _complaints.addAll(newItems);

    _hasMore = newItems.length == _size;
    if (mounted) setState(() {});
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isFetchingMore) return;

    final vmState = ref.read(complaintViewModelProvider);
    if (vmState.isLoadingList) return;

    _isFetchingMore = true;
    _page += 1;

    await ref
        .read(complaintViewModelProvider.notifier)
        .fetchAllComplaints(
          pageNumber: _page,
          pageSize: _size,
          sortByCreatedAt: _sortAscending,
          sortByStatus: _selectedStatus?.label,
        );

    final state = ref.read(complaintViewModelProvider);
    final newItems = state.listData?.data ?? [];
    _complaints.addAll(newItems);

    _hasMore = newItems.length == _size;
    _isFetchingMore = false;
    if (mounted) setState(() {});
  }

  void _onSelectFilter(ComplaintStatus? status) {
    if (_selectedStatus == status) return;
    setState(() => _selectedStatus = status);
    _refresh();
  }

  void _toggleSort() {
    setState(() => _sortAscending = !_sortAscending);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    final vmState = ref.watch(complaintViewModelProvider);
    final isFirstLoading = vmState.isLoadingList && _complaints.isEmpty;
    final error = vmState.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.complaint_list),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: theme.primaryColor,
            ),
            onPressed: _toggleSort,
            tooltip: s.sort_by_date,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding),
          child: Column(
            children: [
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      context,
                      label: s.all,
                      isSelected: _selectedStatus == null,
                      onTap: () => _onSelectFilter(null),
                      color: theme.primaryColor,
                    ),
                    SizedBox(width: spacing.screenPadding / 2),
                    _buildFilterChip(
                      context,
                      label: s.complaint_submitted,
                      isSelected: _selectedStatus == ComplaintStatus.submitted,
                      onTap: () => _onSelectFilter(ComplaintStatus.submitted),
                      color: ComplaintStatusHelper.getStatusColor(
                        context,
                        ComplaintStatus.submitted,
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding / 2),
                    _buildFilterChip(
                      context,
                      label: s.complaint_in_review,
                      isSelected: _selectedStatus == ComplaintStatus.inReview,
                      onTap: () => _onSelectFilter(ComplaintStatus.inReview),
                      color: ComplaintStatusHelper.getStatusColor(
                        context,
                        ComplaintStatus.inReview,
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding / 2),
                    _buildFilterChip(
                      context,
                      label: s.complaint_resolved,
                      isSelected: _selectedStatus == ComplaintStatus.resolved,
                      onTap: () => _onSelectFilter(ComplaintStatus.resolved),
                      color: ComplaintStatusHelper.getStatusColor(
                        context,
                        ComplaintStatus.resolved,
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding / 2),
                    _buildFilterChip(
                      context,
                      label: s.complaint_dismissed,
                      isSelected: _selectedStatus == ComplaintStatus.dismissed,
                      onTap: () => _onSelectFilter(ComplaintStatus.dismissed),
                      color: ComplaintStatusHelper.getStatusColor(
                        context,
                        ComplaintStatus.dismissed,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacing.screenPadding),

              // List
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (isFirstLoading) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                        child: const Center(child: RotatingLeafLoader()),
                      );
                    }

                    if (error != null && _complaints.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: theme.hintColor,
                            ),
                            SizedBox(height: spacing.screenPadding),
                            Text(s.error_occurred, style: textTheme.bodyLarge),
                            SizedBox(height: spacing.screenPadding),
                            ElevatedButton(
                              onPressed: _refresh,
                              child: Text(s.retry),
                            ),
                          ],
                        ),
                      );
                    }

                    if (_complaints.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.report_off_outlined,
                              size: 64,
                              color: theme.hintColor,
                            ),
                            SizedBox(height: spacing.screenPadding),
                            Text(
                              s.no_complaints,
                              style: textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: _complaints.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _complaints.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final complaint = _complaints[index];
                        return _buildComplaintCard(
                          context,
                          complaint,
                          spacing,
                          s,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? theme.scaffoldBackgroundColor : color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: color,
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(
        color: isSelected ? color : color.withValues(alpha: 0.3),
        width: isSelected ? 2 : 1,
      ),
      checkmarkColor: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildComplaintCard(
    BuildContext context,
    ComplaintEntity complaint,
    AppSpacing spacing,
    S s,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final space = spacing.screenPadding;
    final status = ComplaintStatus.fromString(complaint.status.label);
    final statusColor = ComplaintStatusHelper.getStatusColor(context, status);
    final statusIcon = ComplaintStatusHelper.getStatusIcon(status);
    final statusLabel = ComplaintStatusHelper.getLocalizedStatus(
      context,
      status,
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: space),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(space)),
      child: InkWell(
        borderRadius: BorderRadius.circular(space),
        onTap: () {
          context.push(
            '/complaint-detail',
            extra: {'complaintId': complaint.complaintId},
          );
        },
        child: Padding(
          padding: EdgeInsets.all(space),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: space * 2 / 3,
                      vertical: space / 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(space * 2 / 3),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        SizedBox(width: space / 3),
                        Text(
                          statusLabel,
                          style: textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 14, color: theme.hintColor),
                  SizedBox(width: space / 3),
                  Text(
                    TimeAgoHelper.format(context, complaint.createdAt),
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: space),

              // Reason
              Text(
                s.complaint_reason,
                style: textTheme.labelSmall?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: space / 3),
              Text(
                complaint.reason,
                style: textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: space),

              // Participants
              Row(
                children: [
                  Expanded(
                    child: _buildUserInfo(
                      context,
                      label: s.complainant,
                      name: complaint.complainant?.fullName ?? s.unknown,
                      avatarUrl: complaint.complainant?.avatarUrl,
                      spacing: spacing,
                    ),
                  ),
                  SizedBox(width: space),
                  Icon(Icons.arrow_forward, color: theme.hintColor, size: 16),
                  SizedBox(width: space),
                  Expanded(
                    child: _buildUserInfo(
                      context,
                      label: s.accused,
                      name: complaint.accused?.fullName ?? s.unknown,
                      avatarUrl: complaint.accused?.avatarUrl,
                      spacing: spacing,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(
    BuildContext context, {
    required String label,
    required String name,
    String? avatarUrl,
    required AppSpacing spacing,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final space = spacing.screenPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: theme.hintColor,
            fontSize: 10,
          ),
        ),
        SizedBox(height: space / 3),
        Row(
          children: [
            CircleAvatar(
              radius: space,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl)
                  : null,
              backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
              child: avatarUrl == null
                  ? Icon(Icons.person, size: space, color: theme.primaryColor)
                  : null,
            ),
            SizedBox(width: space / 2),
            Expanded(
              child: Text(
                name,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
