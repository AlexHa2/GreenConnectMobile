class Transaction {
  final String id;
  final String status;
  final double? weight;
  final double? value;
  final String? collectorNote;
  final String? householdNote;
  final DateTime? scheduledAt;
  final DateTime? checkedInAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Offer information
  final TransactionOffer? offer;
  
  // Feedback information
  final List<TransactionFeedback>? feedbacks;

  Transaction({
    required this.id,
    required this.status,
    this.weight,
    this.value,
    this.collectorNote,
    this.householdNote,
    this.scheduledAt,
    this.checkedInAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.offer,
    this.feedbacks,
  });

  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';
  bool get isPending => status == 'PENDING';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isAwaitingConfirmation => status == 'AWAITING_CONFIRMATION';

  // Check if user can check-in (collector only)
  bool canCheckIn() => status == 'PENDING';
  
  // Check if user can input details (collector only)
  bool canInputDetails() => status == 'IN_PROGRESS';
  
  // Check if user can approve/reject (household only)
  bool canProcess() => status == 'AWAITING_CONFIRMATION';
  
  // Check if user can cancel
  bool canCancel() => status == 'PENDING' || status == 'IN_PROGRESS';
  
  // Check if user can provide feedback
  bool canProvideFeedback() => status == 'COMPLETED' && (feedbacks == null || feedbacks!.isEmpty);
}

class TransactionOffer {
  final String id;
  final String status;
  final ScrapPost? scrapPost;
  final ScrapCollector? scrapCollector;
  final List<OfferDetail>? offerDetails;

  TransactionOffer({
    required this.id,
    required this.status,
    this.scrapPost,
    this.scrapCollector,
    this.offerDetails,
  });
}

class ScrapPost {
  final String id;
  final String title;
  final String? description;
  final String? address;
  final String? imageUrl;
  final Household? household;

  ScrapPost({
    required this.id,
    required this.title,
    this.description,
    this.address,
    this.imageUrl,
    this.household,
  });
}

class Household {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;

  Household({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
  });
}

class ScrapCollector {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;

  ScrapCollector({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
  });
}

class OfferDetail {
  final String id;
  final String scrapType;
  final double quantity;
  final double pricePerUnit;
  final double totalPrice;

  OfferDetail({
    required this.id,
    required this.scrapType,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalPrice,
  });
}

class TransactionFeedback {
  final String id;
  final String providedBy;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  TransactionFeedback({
    required this.id,
    required this.providedBy,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
