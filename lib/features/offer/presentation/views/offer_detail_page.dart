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
  late OfferActionHandler _actionHandler;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(offerViewModelProvider.notifier)
          .fetchOfferDetail(widget.offerId);
    });
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
                  ),
                  SizedBox(height: spacing),

                  // Schedule proposals
                  ScheduleProposalsSection(
                    schedules: offer.scheduleProposals,
                    theme: theme,
                    spacing: spacing,
                    s: s,
                    isHouseholdView: !widget.isCollectorView,
                    onRejectSchedule: !widget.isCollectorView
                        ? (scheduleId) => _actionHandler
                            .handleProcessSchedule(
                              scheduleId: scheduleId,
                              isAccepted: false,
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
