import 'package:GreenConnectMobile/features/transaction/data/datasources/transaction_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/check_in_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_all_transactions_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_transaction_detail_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_transaction_feedbacks_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_transactions_by_offer_id_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/process_transaction_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/toggle_cancel_transaction_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/update_transaction_details_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/viewmodels/states/transaction_state.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/viewmodels/transaction_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final transactionRemoteDsProvider =
    Provider<TransactionRemoteDataSourceImpl>((ref) {
  return TransactionRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final ds = ref.read(transactionRemoteDsProvider);
  return TransactionRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Get all transactions
final getAllTransactionsUsecaseProvider =
    Provider<GetAllTransactionsUsecase>((ref) {
  return GetAllTransactionsUsecase(ref.read(transactionRepositoryProvider));
});

// Get transaction detail
final getTransactionDetailUsecaseProvider =
    Provider<GetTransactionDetailUsecase>((ref) {
  return GetTransactionDetailUsecase(ref.read(transactionRepositoryProvider));
});

// Check in
final checkInUsecaseProvider = Provider<CheckInUsecase>((ref) {
  return CheckInUsecase(ref.read(transactionRepositoryProvider));
});

// Update transaction details
final updateTransactionDetailsUsecaseProvider =
    Provider<UpdateTransactionDetailsUsecase>((ref) {
  return UpdateTransactionDetailsUsecase(
      ref.read(transactionRepositoryProvider));
});

// Process transaction
final processTransactionUsecaseProvider =
    Provider<ProcessTransactionUsecase>((ref) {
  return ProcessTransactionUsecase(ref.read(transactionRepositoryProvider));
});

// Toggle cancel transaction
final toggleCancelTransactionUsecaseProvider =
    Provider<ToggleCancelTransactionUsecase>((ref) {
  return ToggleCancelTransactionUsecase(
      ref.read(transactionRepositoryProvider));
});

// Get transaction feedbacks
final getTransactionFeedbacksUsecaseProvider =
    Provider<GetTransactionFeedbacksUsecase>((ref) {
  return GetTransactionFeedbacksUsecase(
      ref.read(transactionRepositoryProvider));
});

// Get transactions by offer ID
final getTransactionsByOfferIdUsecaseProvider =
    Provider<GetTransactionsByOfferIdUsecase>((ref) {
  return GetTransactionsByOfferIdUsecase(
      ref.read(transactionRepositoryProvider));
});

/// =============
///  ViewModel
/// =============
final transactionViewModelProvider =
    NotifierProvider<TransactionViewModel, TransactionState>(
  () => TransactionViewModel(),
);
