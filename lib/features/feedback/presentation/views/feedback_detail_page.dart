import 'package:GreenConnectMobile/features/feedback/presentation/providers/feedback_providers.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/feedback_info_section.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/feedback_states.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/transaction_section.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/update_feedback_dialog.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/user_info_section.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackDetailPage extends ConsumerStatefulWidget {
  final String feedbackId;

  const FeedbackDetailPage({super.key, required this.feedbackId});

  @override
  ConsumerState<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends ConsumerState<FeedbackDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeedbackDetail();
    });
  }

  Future<void> _loadFeedbackDetail() async {
    await ref
        .read(feedbackViewModelProvider.notifier)
        .fetchFeedbackDetail(widget.feedbackId);
  }

  Future<void> _handleUpdate() async {
    final s = S.of(context)!;
    final currentFeedback = ref.read(feedbackViewModelProvider).detailData;

    if (currentFeedback == null) return;

    final result = await UpdateFeedbackDialog.show(
      context: context,
      currentRating: currentFeedback.rate,
      currentComment: currentFeedback.comment,
    );

    if (result != null && mounted) {
      final success = await ref
          .read(feedbackViewModelProvider.notifier)
          .updateFeedback(
            feedbackId: widget.feedbackId,
            rate: result['rating'] as int?,
            comment: result['comment'] as String?,
          );

      if (mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.feedback_updated_success,
            type: ToastType.success,
          );
          _loadFeedbackDetail();
        } else {
          CustomToast.show(
            context,
            s.update_feedback_failed,
            type: ToastType.error,
          );
        }
      }
    }
  }

  Future<void> _handleDelete() async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing),
        ),
        title: Text(s.delete_feedback),
        content: Text(s.are_you_sure),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              s.cancel,
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: theme.scaffoldBackgroundColor,
            ),
            child: Text(s.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref
          .read(feedbackViewModelProvider.notifier)
          .deleteFeedback(widget.feedbackId);

      if (mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.feedback_deleted_success,
            type: ToastType.success,
          );
          // Return true to indicate refresh is needed
          Navigator.pop(context, true);
        } else {
          CustomToast.show(
            context,
            s.delete_feedback_failed,
            type: ToastType.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;
    final feedbackState = ref.watch(feedbackViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.cardColor,
        title: Text(
          s.feedback_details,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          if (feedbackState.detailData != null)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: theme.primaryColor),
                      SizedBox(width: spacing * 0.8),
                      Text(
                        s.edit_feedback,
                        style: TextStyle(color: theme.primaryColor),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: s.delete,
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: AppColors.danger),
                      SizedBox(width: spacing * 0.8),
                      Text(
                        s.delete_feedback,
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _handleUpdate();
                } else if (value == s.delete) {
                  _handleDelete();
                }
              },
            ),
        ],
      ),
      body: _buildContent(feedbackState, theme, spacing, s),
    );
  }

  Widget _buildContent(
    dynamic feedbackState,
    ThemeData theme,
    double spacing,
    S s,
  ) {
    if (feedbackState.isLoadingDetail) {
      return const Center(child: RotatingLeafLoader());
    }

    if (feedbackState.errorMessage != null) {
      return _buildErrorState(feedbackState.errorMessage!, theme, spacing, s);
    }

    if (feedbackState.detailData == null) {
      return _buildEmptyState(theme, spacing, s);
    }

    final feedback = feedbackState.detailData!;

    return RefreshIndicator(
      onRefresh: _loadFeedbackDetail,
      color: theme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feedback Information Section
            FeedbackInfoSection(
              rating: feedback.rate,
              comment: feedback.comment,
              createdAt: feedback.createdAt,
            ),

            // SizedBox(height: spacing * 1.5),

            // // Reviewer Section
            // UserInfoSection(
            //   user: feedback.reviewer,
            //   title: s.reviewer_information,
            //   isReviewer: true,
            // ),
            SizedBox(height: spacing * 1.5),

            // Reviewee Section
            UserInfoSection(
              user: feedback.reviewee,
              title: s.reviewee_information,
              isReviewer: false,
            ),

            SizedBox(height: spacing * 1.5),

            // Transaction Section (if available)
            if (feedback.transaction != null)
              TransactionSection(transactionId: feedback.transactionId),

            SizedBox(height: spacing * 2),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(ThemeData theme, double spacing, S s) {
    return FeedbackEmptyState(
      title: s.feedback_not_found,
      subtitle: s.feedback_may_have_been_deleted,
    );
  }

  Widget _buildErrorState(String error, ThemeData theme, double spacing, S s) {
    return FeedbackErrorState(
      error: error,
      onRetry: _loadFeedbackDetail,
    );
  }
}
