import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/action_buttons_section.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/collector_info_section.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/error_state_widget.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/offer_action_handler.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/post_info_section.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/pricing_info_section.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/schedule_proposals_section.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/status_header_section.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfferDetailPage extends ConsumerStatefulWidget {
  final String offerId;
  final bool isCollectorView;

  const OfferDetailPage({
    super.key,
    required this.offerId,
    this.isCollectorView = false,
  });

  @override
  ConsumerState<OfferDetailPage> createState() => _OfferDetailPageState();
}

class _OfferDetailPageState extends ConsumerState<OfferDetailPage> {
  final TokenStorageService _tokenStorage = sl<TokenStorageService>();
  late OfferActionHandler _actionHandler;
  bool _hasChanges = false;
  Role _userRole = Role.household;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserRole();
      ref
          .read(offerViewModelProvider.notifier)
          .fetchOfferDetail(widget.offerId);
    });
  }

  Future<void> _loadUserRole() async {
    final user = await _tokenStorage.getUserData();
    if (user != null && user.roles.isNotEmpty) {
      setState(() {
        if (Role.hasRole(user.roles, Role.household)) {
          _userRole = Role.household;
        } else if (Role.hasRole(user.roles, Role.individualCollector)) {
          _userRole = Role.individualCollector;
        } else if (Role.hasRole(user.roles, Role.businessCollector)) {
          _userRole = Role.businessCollector;
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actionHandler = OfferActionHandler(
      context: context,
      ref: ref,
      offerId: widget.offerId,
      onActionCompleted: () {
        setState(() {
          _hasChanges = true;
        });
      },
    );
  }

  Future<void> _handleUpdateOfferDetail({
    required String detailId,
    required double price,
    required String unit,
  }) async {
    final s = S.of(context)!;
    final success = await ref
        .read(offerViewModelProvider.notifier)
        .updateOfferDetail(
          offerId: widget.offerId,
          detailId: detailId,
          pricePerUnit: price,
          unit: unit,
        );

    if (success && mounted) {
      setState(() {
        _hasChanges = true;
      });
      CustomToast.show(
        context,
        s.pricing_updated_successfully,
        type: ToastType.success,
      );
      _onRefresh();
    } else if (mounted) {
      CustomToast.show(
        context,
        s.failed_to_update_pricing,
        type: ToastType.error,
      );
    }
  }

  Future<void> _handleDeleteOfferDetail(String detailId) async {
    final s = S.of(context)!;
    final success = await ref
        .read(offerViewModelProvider.notifier)
        .deleteOfferDetail(offerId: widget.offerId, detailId: detailId);

    if (success && mounted) {
      setState(() {
        _hasChanges = true;
      });
      CustomToast.show(
        context,
        s.pricing_deleted_successfully,
        type: ToastType.success,
      );
      _onRefresh();
    } else {
      if (mounted) {
        CustomToast.show(
          context,
          s.failed_to_delete_pricing,
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await ref
        .read(offerViewModelProvider.notifier)
        .fetchOfferDetail(widget.offerId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;
    final offerState = ref.watch(offerViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.cardColor,
        title: Text(
          s.offer_details,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context, _hasChanges),
        ),
      ),
      body: _buildBody(offerState, theme, spacing, s),
    );
  }

  Widget _buildBody(dynamic offerState, ThemeData theme, double spacing, S s) {
    if (offerState.isLoadingDetail) {
      return const Center(child: RotatingLeafLoader());
    }

    if (offerState.errorMessage != null) {
      return ErrorStateWidget(
        error: offerState.errorMessage!,
        theme: theme,
        spacing: spacing,
        s: s,
        onRetry: () => ref
            .read(offerViewModelProvider.notifier)
            .fetchOfferDetail(widget.offerId),
      );
    }

    if (offerState.detailData == null) {
      return Center(
        child: Text(s.no_offers_found, style: theme.textTheme.bodyLarge),
      );
    }

    final offer = offerState.detailData!;

    return Column(
      children: [
        // Status header
        StatusHeaderSection(
          status: offer.status,
          createdAt: offer.createdAt,
          theme: theme,
          spacing: spacing,
          s: s,
        ),

        // Content
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collector information
                  if (offer.scrapCollector != null) ...[
                    CollectorInfoSection(
                      collector: offer.scrapCollector!,
                      theme: theme,
                      spacing: spacing,
                      s: s,
                    ),
                    SizedBox(height: spacing),
                  ],

                  // Pricing information
                  PricingInfoSection(
                    offerDetails: offer.offerDetails,
                    theme: theme,
                    spacing: spacing,
                    s: s,
                    offerStatus: offer.status,
                    mustTakeAll: offer.scrapPost?.mustTakeAll,
                    userRole: _userRole,
                    onUpdate: widget.isCollectorView
                        ? (detailId, price, unit) => _handleUpdateOfferDetail(
                            detailId: detailId,
                            price: price,
                            unit: unit,
                          )
                        : null,
                    onDelete: widget.isCollectorView
                        ? _handleDeleteOfferDetail
                        : null,
                  ),
                  SizedBox(height: spacing),

                  // Schedule proposals
                  ScheduleProposalsSection(
                    schedules: offer.scheduleProposals,
                    theme: theme,
                    spacing: spacing,
                    s: s,
                    isHouseholdView: !widget.isCollectorView,
                    offerStatus: offer.status.label,
                    onRejectSchedule: !widget.isCollectorView
                        ? (scheduleId) => _actionHandler.handleProcessSchedule(
                            scheduleId: scheduleId,
                            isAccepted: false,
                          )
                        : null,
                    onReschedule:
                        widget.isCollectorView &&
                            offer.status == OfferStatus.pending
                        ? (proposedTime, responseMessage) =>
                              _actionHandler.handleReschedule(
                                proposedTime: proposedTime,
                                responseMessage: responseMessage,
                              )
                        : null,
                    onUpdateSchedule:
                        widget.isCollectorView &&
                            offer.status == OfferStatus.pending
                        ? (scheduleId, proposedTime, responseMessage) =>
                              _actionHandler.handleUpdateSchedule(
                                scheduleId: scheduleId,
                                proposedTime: proposedTime,
                                responseMessage: responseMessage,
                              )
                        : null,
                  ),
                  SizedBox(height: spacing),

                  // Post information
                  if (offer.scrapPost != null) ...[
                    PostInfoSection(
                      post: offer.scrapPost!,
                      theme: theme,
                      spacing: spacing,
                      s: s,
                    ),
                    SizedBox(height: spacing * 6),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Action buttons
        ActionButtonsSection(
          status: offer.status,
          isCollectorView: widget.isCollectorView,
          theme: theme,
          spacing: spacing,
          s: s,
          onAccept: _actionHandler.handleAcceptOffer,
          onReject: _actionHandler.handleRejectOffer,
          onCancel: _actionHandler.handleCancelOffer,
          onRestore: _actionHandler.handleRestoreOffer,
        ),
      ],
    );
  }
}
