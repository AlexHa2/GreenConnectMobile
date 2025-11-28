import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collector_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/offer_detail_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';

class CollectionOfferEntity {
  final String collectionOfferId;
  final String scrapPostId;
  final ScrapPostEntity? scrapPost;
  final CollectorEntity? scrapCollector;
  final OfferStatus status;
  final DateTime createdAt;
  final List<OfferDetailEntity> offerDetails;
  final List<ScheduleProposalEntity> scheduleProposals;

  CollectionOfferEntity({
    required this.collectionOfferId,
    required this.scrapPostId,
    this.scrapPost,
    this.scrapCollector,
    required this.status,
    required this.createdAt,
    required this.offerDetails,
    required this.scheduleProposals,
  });

  // Backward compatibility getter
  CollectorEntity? get collector => scrapCollector;
}
