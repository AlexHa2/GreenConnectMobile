import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/offer_detail_page.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/providers/schedule_providers.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/viewmodels/states/schedule_state.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:GreenConnectMobile/shared/widgets/select_meeting_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SchedulesListPage extends ConsumerStatefulWidget {
  const SchedulesListPage({super.key});

  @override
  ConsumerState<SchedulesListPage> createState() => _SchedulesListPageState();
}

class _SchedulesListPageState extends ConsumerState<SchedulesListPage> {
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  ScheduleProposalStatus? _selectedStatus;
  bool _sortByCreateAtDesc = true;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Chỉ fetch nếu chưa có data
      final currentState = ref.read(scheduleViewModelProvider);
      if (currentState.listData == null || 
          currentState.listData!.data.isEmpty) {
        _loadSchedules(isRefresh: true);
      } else {
        // Có data rồi, chỉ cần sync lại state
        setState(() {
          _hasMoreData = currentState.listData!.data.length >= _pageSize;
          _hasInitialized = true;
        });
      }
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
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreSchedules();
    }
  }

  Future<void> _loadSchedules({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
    }

    // Lưu data hiện tại trước khi fetch (để merge khi load more)
    final currentData = isRefresh 
        ? <ScheduleProposalEntity>[]
        : (ref.read(scheduleViewModelProvider).listData?.data ?? []);

    await ref
        .read(scheduleViewModelProvider.notifier)
        .fetchAllSchedules(
          status: _selectedStatus?.name,
          sortByCreateAtDesc: _sortByCreateAtDesc,
          page: _currentPage,
          size: _pageSize,
        );

    final state = ref.read(scheduleViewModelProvider);
    if (mounted && state.listData != null) {
      setState(() {
        if (!isRefresh && currentData.isNotEmpty) {
          // Merge data khi load more
          final newData = state.listData!.data;
          final allData = [...currentData, ...newData];
          state.listData!.data
            ..clear()
            ..addAll(allData);
        }
        _hasMoreData = state.listData!.data.length >= _pageSize;
        _hasInitialized = true;
      });
    }
  }

  Future<void> _loadMoreSchedules() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    final currentData = ref.read(scheduleViewModelProvider).listData?.data ?? [];

    await ref
        .read(scheduleViewModelProvider.notifier)
        .fetchAllSchedules(
          status: _selectedStatus?.name,
          sortByCreateAtDesc: _sortByCreateAtDesc,
          page: _currentPage,
          size: _pageSize,
        );

    if (!mounted) return;

    final state = ref.read(scheduleViewModelProvider);
    setState(() {
      _isLoadingMore = false;
      if (state.listData != null) {
        final newData = state.listData!.data;
        _hasMoreData = newData.length >= _pageSize;

        final allData = [...currentData, ...newData];
        state.listData!.data
          ..clear()
          ..addAll(allData);
      }
    });
  }

  Future<void> _onRefresh() async {
    await _loadSchedules(isRefresh: true);
  }

  Future<void> _showEditScheduleDialog(
    BuildContext context,
    ScheduleProposalEntity schedule,
  ) async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    DateTime selectedTime = schedule.proposedTime;
    final TextEditingController messageController = TextEditingController(
      text: schedule.responseMessage,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spacing),
            ),
            title: Row(
              children: [
                Icon(Icons.edit_calendar, color: theme.primaryColor),
                SizedBox(width: spacing / 2),
                Expanded(
                  child: Text(
                    s.scheduleRescheduleButton,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.select_meeting_time,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing / 2),
                  InkWell(
                    onTap: () async {
                      // First select date
                      DateTime? pickedDate;
                      await showSelectMeetingDialog(
                        title: s.select_meeting_time,
                        context: context,
                        initialDate: selectedTime,
                        onDateSelected: (date) {
                          pickedDate = date;
                        },
                        onAccept: () {
                          Navigator.pop(context);
                        },
                        onDecline: () {
                          Navigator.pop(context);
                        },
                      );
                      
                      if (pickedDate != null && context.mounted) {
                        // Then select time
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedTime),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: theme.primaryColor,
                                  onPrimary: Colors.white,
                                  surface: theme.scaffoldBackgroundColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        
                        if (pickedTime != null && context.mounted) {
                          setDialogState(() {
                            selectedTime = DateTime(
                              pickedDate!.year,
                              pickedDate!.month,
                              pickedDate!.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(spacing / 2),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: spacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.proposed_time,
                                  style: theme.textTheme.bodySmall,
                                ),
                                SizedBox(height: spacing / 4),
                                Text(
                                  selectedTime.toCustomFormat(
                                    locale: s.localeName,
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing * 1.5),
                  Text(
                    s.message_optional,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing / 2),
                  TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: s.enter_your_message,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing / 2),
                      ),
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(s.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _updateSchedule(
                    context,
                    schedule.scheduleProposalId,
                    selectedTime,
                    messageController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(s.update),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateSchedule(
    BuildContext context,
    String scheduleId,
    DateTime proposedTime,
    String responseMessage,
  ) async {
    final s = S.of(context)!;
    // final theme = Theme.of(context);

    final request = UpdateScheduleRequest(
      proposedTime: proposedTime,
      responseMessage: responseMessage,
    );

    final success = await ref
        .read(scheduleViewModelProvider.notifier)
        .updateSchedule(
          scheduleId: scheduleId,
          request: request,
        );

    if (!context.mounted) return;

    if (success) {
      CustomToast.show(
        context,
        s.scheduleUpdateSuccess,
        type: ToastType.success,
      );
      await _onRefresh();
    } else {
      final errorState = ref.read(scheduleViewModelProvider);
      final errorMessage = errorState.errorMessage ?? s.action_failed;
      
      // Check for specific error codes
      String displayMessage = errorMessage;
      if (errorMessage.contains('400') || 
          errorMessage.contains('Không thể sửa')) {
        displayMessage = 
            'Không thể sửa vì đề xuất đã được Chấp nhận hoặc Từ chối.';
      } else if (errorMessage.contains('403') || 
                 errorMessage.contains('quyền')) {
        displayMessage = 'Không có quyền sửa đề xuất này.';
      }

      CustomToast.show(
        context,
        displayMessage,
        type: ToastType.error,
      );
    }
  }

  Future<void> _showCreateScheduleDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final offerIdController = TextEditingController();
    DateTime selectedTime = DateTime.now().add(const Duration(days: 1));
    final messageController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spacing),
            ),
            title: Row(
              children: [
                Icon(Icons.add_circle_outline, color: theme.primaryColor),
                SizedBox(width: spacing / 2),
                Expanded(
                  child: Text(
                    'Tạo lịch hẹn mới',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Offer ID input
                  Text(
                    'Offer ID',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing / 2),
                  TextField(
                    controller: offerIdController,
                    decoration: InputDecoration(
                      hintText: 'Nhập ID của đề nghị',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing / 2),
                      ),
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                      prefixIcon: const Icon(Icons.tag),
                    ),
                  ),
                  SizedBox(height: spacing * 1.5),
                  // Time selection
                  Text(
                    s.select_meeting_time,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing / 2),
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate;
                      await showSelectMeetingDialog(
                        title: s.select_meeting_time,
                        context: context,
                        initialDate: selectedTime,
                        onDateSelected: (date) {
                          pickedDate = date;
                        },
                        onAccept: () {
                          Navigator.pop(context);
                        },
                        onDecline: () {
                          Navigator.pop(context);
                        },
                      );
                      
                      if (pickedDate != null && context.mounted) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedTime),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: theme.primaryColor,
                                  onPrimary: theme.scaffoldBackgroundColor,
                                  surface: theme.scaffoldBackgroundColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        
                        if (pickedTime != null && context.mounted) {
                          setDialogState(() {
                            selectedTime = DateTime(
                              pickedDate!.year,
                              pickedDate!.month,
                              pickedDate!.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(spacing / 2),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: spacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.proposed_time,
                                  style: theme.textTheme.bodySmall,
                                ),
                                SizedBox(height: spacing / 4),
                                Text(
                                  selectedTime.toCustomFormat(
                                    locale: s.localeName,
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing * 1.5),
                  // Message input
                  Text(
                    s.message_optional,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing / 2),
                  TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: s.enter_your_message,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing / 2),
                      ),
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(s.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (offerIdController.text.trim().isEmpty) {
                    CustomToast.show(
                      context,
                      'Vui lòng nhập Offer ID',
                      type: ToastType.warning,
                    );
                    return;
                  }
                  Navigator.pop(dialogContext);
                  await _createSchedule(
                    context,
                    offerIdController.text.trim(),
                    selectedTime,
                    messageController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(s.create),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createSchedule(
    BuildContext context,
    String offerId,
    DateTime proposedTime,
    String responseMessage,
  ) async {
    final s = S.of(context)!;

    final request = CreateScheduleRequest(
      proposedTime: proposedTime.toIso8601String(),
      responseMessage: responseMessage,
    );

    final success = await ref
        .read(scheduleViewModelProvider.notifier)
        .createSchedule(
          offerId: offerId,
          request: request,
        );

    if (!context.mounted) return;

    if (success) {
      CustomToast.show(
        context,
        'Tạo lịch hẹn thành công',
        type: ToastType.success,
      );
      await _onRefresh();
    } else {
      final errorState = ref.read(scheduleViewModelProvider);
      final errorMessage = errorState.errorMessage ?? s.action_failed;
      
      String displayMessage = errorMessage;
      if (errorMessage.contains('400') || 
          errorMessage.contains('Bad Request')) {
        displayMessage = 'Offer không hợp lệ hoặc đã có schedule.';
      } else if (errorMessage.contains('403') || 
                 errorMessage.contains('Forbidden')) {
        displayMessage = 'Bạn không có quyền tạo lịch hẹn cho offer này.';
      } else if (errorMessage.contains('404') || 
                 errorMessage.contains('Not Found')) {
        displayMessage = 'Không tìm thấy offer.';
      }

      CustomToast.show(
        context,
        displayMessage,
        type: ToastType.error,
      );
    }
  }

  Future<void> _toggleCancelSchedule(
    BuildContext context,
    ScheduleProposalEntity schedule,
  ) async {
    final s = S.of(context)!;
    final theme = Theme.of(context);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.extension<AppSpacing>()?.screenPadding ?? 12.0),
        ),
        title: Text(
          schedule.status == ScheduleProposalStatus.pending
              ? s.scheduleConfirmCancel
              : s.scheduleRestoreButton,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          schedule.status == ScheduleProposalStatus.pending
              ? s.scheduleCancelMessage
              : 'Bạn có chắc chắn muốn khôi phục lịch hẹn này?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: schedule.status == ScheduleProposalStatus.pending
                  ? AppColors.danger
                  : theme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              schedule.status == ScheduleProposalStatus.pending
                  ? s.scheduleCancelButton
                  : s.scheduleRestoreButton,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(scheduleViewModelProvider.notifier)
        .toggleCancelSchedule(schedule.scheduleProposalId);

    if (!context.mounted) return;

    if (success) {
      CustomToast.show(
        context,
        schedule.status == ScheduleProposalStatus.pending
            ? s.scheduleCancelSuccess
            : s.scheduleRestoreSuccess,
        type: ToastType.success,
      );
      await _onRefresh();
    } else {
      final errorState = ref.read(scheduleViewModelProvider);
      final errorMessage = errorState.errorMessage ?? s.action_failed;
      
      // Check for specific error codes
      String displayMessage = errorMessage;
      if (errorMessage.contains('400') || 
          errorMessage.contains('Không thể hủy') ||
          errorMessage.contains('đã được Chấp nhận')) {
        displayMessage = 
            'Không thể hủy đề xuất đã được Chấp nhận.';
      } else if (errorMessage.contains('403') || 
                 errorMessage.contains('quyền')) {
        displayMessage = 'Không có quyền thao tác.';
      }

      CustomToast.show(
        context,
        displayMessage,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;
    final scheduleState = ref.watch(scheduleViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          // Header
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(spacing * 0.7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.linearPrimary,
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.scheduleListTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.schedules_count(
                          scheduleState.listData?.pagination.totalRecords ??
                              scheduleState.listData?.data.length ??
                              0,
                        ),
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
                      _sortByCreateAtDesc = !_sortByCreateAtDesc;
                    });
                    _loadSchedules(isRefresh: true);
                  },
                  icon: Icon(
                    _sortByCreateAtDesc
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                  ),
                  tooltip: s.sort_by_creation_date,
                ),
              ],
            ),
          ),
          // Filter chips
          Container(
            color: theme.cardColor,
            padding: EdgeInsets.symmetric(
              horizontal: spacing,
              vertical: spacing * 0.75,
            ),
            child: _buildStatusFilterChips(theme, s, spacing),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(
            child: _buildContent(
              context,
              theme,
              spacing,
              s,
              scheduleState,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateScheduleDialog(context),
        icon: const Icon(Icons.add),
        label: Text('Tạo lịch hẹn mới'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatusFilterChips(ThemeData theme, S s, double spacing) {
    final chips = <({ScheduleProposalStatus? status, String label})>[
      (status: null, label: s.scheduleStatusAll),
      (
        status: ScheduleProposalStatus.pending,
        label: s.scheduleStatusPending
      ),
      (
        status: ScheduleProposalStatus.accepted,
        label: s.scheduleStatusAccepted
      ),
      (
        status: ScheduleProposalStatus.rejected,
        label: s.scheduleStatusRejected
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((chip) {
          final bool isSelected = _selectedStatus == chip.status;
          return Padding(
            padding: EdgeInsets.only(right: spacing * 0.5),
            child: ChoiceChip(
              label: Text(
                chip.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodySmall?.color,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedStatus = chip.status;
                });
                _loadSchedules(isRefresh: true);
              },
              selectedColor: theme.primaryColor,
              backgroundColor: theme.cardColor,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? theme.primaryColor
                      : theme.dividerColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    double spacing,
    S s,
    ScheduleState scheduleState,
  ) {
    if (scheduleState.isLoadingList && scheduleState.listData == null) {
      return const Center(child: RotatingLeafLoader());
    }

    if (scheduleState.errorMessage != null && scheduleState.listData == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Text(
            scheduleState.errorMessage!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final List<ScheduleProposalEntity> schedules =
        scheduleState.listData?.data ?? [];

    if (schedules.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.primaryColor,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: spacing * 4),
            Icon(
              Icons.event_busy,
              size: 64,
              color: theme.disabledColor,
            ),
            SizedBox(height: spacing),
            Center(
              child: Text(
                s.scheduleEmptyMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: theme.primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(spacing),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: schedules.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == schedules.length && _isLoadingMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: spacing),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final schedule = schedules[index];
          return _ScheduleCard(
            schedule: schedule,
            spacing: spacing,
            s: s,
            onChanged: _onRefresh,
            onEdit: (schedule) => _showEditScheduleDialog(context, schedule),
            onToggleCancel: (schedule) => _toggleCancelSchedule(context, schedule),
          );
        },
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ScheduleProposalEntity schedule;
  final double spacing;
  final S s;
  final Future<void> Function() onChanged;
  final void Function(ScheduleProposalEntity) onEdit;
  final void Function(ScheduleProposalEntity) onToggleCancel;

  const _ScheduleCard({
    required this.schedule,
    required this.spacing,
    required this.s,
    required this.onChanged,
    required this.onEdit,
    required this.onToggleCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final proposedTime = schedule.proposedTime;
    final createdAt = schedule.createdAt;
    final status = schedule.status;
    final post = schedule.collectionOffer?.scrapPost;
    final address = post?.address;

    return Card(
      margin: EdgeInsets.only(bottom: spacing),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(spacing),
        onTap: () async {
          await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => OfferDetailPage(
                offerId: schedule.collectionOfferId,
                isCollectorView: true,
              ),
            ),
          );
          await onChanged();
        },
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status & created time
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing * 0.8,
                      vertical: spacing * 0.4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(status),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: _getStatusColor(status),
                        ),
                        SizedBox(width: spacing * 0.4),
                        Text(
                          ScheduleProposalStatus.labelS(context, status),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  SizedBox(width: spacing / 3),
                  Text(
                    DateFormat.yMd().add_Hm().format(createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

              SizedBox(height: spacing),

              // Proposed time
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(spacing * 0.6),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.event_note,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.proposed_time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          proposedTime.toCustomFormat(
                            locale: s.localeName,
                          ),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (address != null && address.isNotEmpty) ...[
                SizedBox(height: spacing * 0.75),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: spacing / 2),
                    Expanded(
                      child: Text(
                        address,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],

              if (schedule.responseMessage.isNotEmpty) ...[
                SizedBox(height: spacing * 0.75),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing * 0.75),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.scheduleResponseMessage,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: spacing / 4),
                      Text(
                        schedule.responseMessage,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: spacing),

              // Footer actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Edit button (only show when status is Pending)
                  if (status == ScheduleProposalStatus.pending) ...[
                    TextButton.icon(
                      onPressed: () => onEdit(schedule),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(s.scheduleRescheduleButton),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.warningUpdate,
                      ),
                    ),
                    SizedBox(width: spacing / 2),
                    // Cancel button (only show when status is Pending)
                    TextButton.icon(
                      onPressed: () => onToggleCancel(schedule),
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text(s.scheduleCancelButton),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.danger,
                      ),
                    ),
                    SizedBox(width: spacing / 2),
                  ],
                  // View details button
                  TextButton.icon(
                    onPressed: () async {
                      await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OfferDetailPage(
                            offerId: schedule.collectionOfferId,
                            isCollectorView: true,
                          ),
                        ),
                      );
                      await onChanged();
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text(s.offer_details),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.primaryColor,
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

  Color _getStatusColor(ScheduleProposalStatus status) {
    switch (status) {
      case ScheduleProposalStatus.pending:
        return AppColors.warningUpdate;
      case ScheduleProposalStatus.accepted:
        return AppColors.primary;
      case ScheduleProposalStatus.rejected:
        return AppColors.danger;
    }
  }
}


