import 'package:GreenConnectMobile/features/offer/data/datasources/offer_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/offer/data/repository/offer_repository_impl.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/add_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/create_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/create_supplementary_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/delete_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_all_offers_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_offers_by_post_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/process_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/toggle_cancel_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/update_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/presentation/viewmodels/offer_view_model.dart';
import 'package:GreenConnectMobile/features/offer/presentation/viewmodels/states/offer_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final offerRemoteDsProvider = Provider<OfferRemoteDataSourceImpl>((ref) {
  return OfferRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final ds = ref.read(offerRemoteDsProvider);
  return OfferRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Create offer
final createOfferUsecaseProvider = Provider<CreateOfferUsecase>((ref) {
  return CreateOfferUsecase(ref.read(offerRepositoryProvider));
});

// Create supplementary offer
final createSupplementaryOfferUsecaseProvider =
    Provider<CreateSupplementaryOfferUsecase>((ref) {
  return CreateSupplementaryOfferUsecase(ref.read(offerRepositoryProvider));
});

// Get offers by post
final getOffersByPostUsecaseProvider = Provider<GetOffersByPostUsecase>((ref) {
  return GetOffersByPostUsecase(ref.read(offerRepositoryProvider));
});

// Get all offers
final getAllOffersUsecaseProvider = Provider<GetAllOffersUsecase>((ref) {
  return GetAllOffersUsecase(ref.read(offerRepositoryProvider));
});

// Get offer detail
final getOfferDetailUsecaseProvider = Provider<GetOfferDetailUsecase>((ref) {
  return GetOfferDetailUsecase(ref.read(offerRepositoryProvider));
});

// Toggle cancel offer
final toggleCancelOfferUsecaseProvider = Provider<ToggleCancelOfferUsecase>((
  ref,
) {
  return ToggleCancelOfferUsecase(ref.read(offerRepositoryProvider));
});

// Process offer
final processOfferUsecaseProvider = Provider<ProcessOfferUsecase>((ref) {
  return ProcessOfferUsecase(ref.read(offerRepositoryProvider));
});

// Add offer detail
final addOfferDetailUsecaseProvider = Provider<AddOfferDetailUsecase>((ref) {
  return AddOfferDetailUsecase(ref.read(offerRepositoryProvider));
});

// Update offer detail
final updateOfferDetailUsecaseProvider = Provider<UpdateOfferDetailUsecase>((
  ref,
) {
  return UpdateOfferDetailUsecase(ref.read(offerRepositoryProvider));
});

// Delete offer detail
final deleteOfferDetailUsecaseProvider = Provider<DeleteOfferDetailUsecase>((
  ref,
) {
  return DeleteOfferDetailUsecase(ref.read(offerRepositoryProvider));
});

/// =============
///  ViewModel
/// =============
final offerViewModelProvider =
    NotifierProvider<OfferViewModel, OfferState>(() => OfferViewModel());
