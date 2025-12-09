import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  /// Get all transactions for current user
  Future<List<Transaction>> getTransactions();
  
  /// Get transaction detail by ID
  Future<Transaction> getTransactionDetail(String transactionId);
  
  /// Collector check-in at collection location
  Future<void> checkIn(String transactionId);
  
  /// Collector inputs transaction details (weight, value, notes)
  Future<void> inputDetails({
    required String transactionId,
    required double weight,
    required double value,
    String? collectorNote,
  });
  
  /// Household approves or rejects transaction
  Future<void> processTransaction({
    required String transactionId,
    required bool isApproved,
    String? householdNote,
  });
  
  /// Cancel transaction (can be done by collector)
  Future<void> cancelTransaction(String transactionId);
  
  /// Get feedbacks for a transaction
  Future<List<TransactionFeedback>> getTransactionFeedbacks(String transactionId);
  
  /// Submit feedback for a transaction
  Future<void> submitFeedback({
    required String transactionId,
    required int rating,
    String? comment,
  });
}
