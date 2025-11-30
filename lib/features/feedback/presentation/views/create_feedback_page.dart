import 'package:GreenConnectMobile/features/feedback/presentation/providers/feedback_providers.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/comment_section.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/feedback_app_bar.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/rating_section.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/submit_button.dart';
import 'package:GreenConnectMobile/features/feedback/utils/feedback_utils.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateFeedbackPage extends ConsumerStatefulWidget {
  final String transactionId;

  const CreateFeedbackPage({super.key, required this.transactionId});

  @override
  ConsumerState<CreateFeedbackPage> createState() => _CreateFeedbackPageState();
}

class _CreateFeedbackPageState extends ConsumerState<CreateFeedbackPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRating == 0) {
      final s = S.of(context)!;
      CustomToast.show(context, s.rating_required, type: ToastType.warning);
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await ref
        .read(feedbackViewModelProvider.notifier)
        .createFeedback(
          transactionId: widget.transactionId,
          rate: _selectedRating,
          comment: _commentController.text.trim(),
        );

    if (mounted) {
      setState(() => _isSubmitting = false);

      final s = S.of(context)!;
      if (success) {
        CustomToast.show(
          context,
          s.feedback_created_success,
          type: ToastType.success,
        );
        context.pop(true);
      } else {
        CustomToast.show(
          context,
          s.create_feedback_failed,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          FeedbackAppBar(title: s.create_feedback),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.all(spacing * 1.5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating Section
                        RatingSection(
                          selectedRating: _selectedRating,
                          onRatingChanged: (rating) {
                            setState(() => _selectedRating = rating);
                          },
                          ratingText: FeedbackUtils.getRatingText(
                            _selectedRating,
                            s,
                          ),
                        ),

                        SizedBox(height: spacing * 2.5),

                        // Comment Section
                        CommentSection(controller: _commentController),

                        SizedBox(height: spacing * 3),

                        // Submit Button
                        SubmitButton(
                          onPressed: _handleSubmit,
                          label: s.submit_feedback,
                          isLoading: _isSubmitting,
                        ),

                        SizedBox(height: spacing),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
