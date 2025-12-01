import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/add_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/create_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/delete_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_all_offers_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_offers_by_post_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/process_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/toggle_cancel_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/update_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/viewmodels/states/offer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfferViewModel extends Notifier<OfferState> {
  late CreateOfferUsecase _createOffer;
  late GetOffersByPostUsecase _getOffersByPost;
  late GetAllOffersUsecase _getAllOffers;
  late GetOfferDetailUsecase _getOfferDetail;
  late ToggleCancelOfferUsecase _toggleCancel;
  late ProcessOfferUsecase _processOffer;
  late AddOfferDetailUsecase _addDetail;
  late UpdateOfferDetailUsecase _updateDetail;
  late DeleteOfferDetailUsecase _deleteDetail;

  @override
  OfferState build() {
    _createOffer = ref.read(createOfferUsecaseProvider);
    _getOffersByPost = ref.read(getOffersByPostUsecaseProvider);
    _getAllOffers = ref.read(getAllOffersUsecaseProvider);
    _getOfferDetail = ref.read(getOfferDetailUsecaseProvider);
    _toggleCancel = ref.read(toggleCancelOfferUsecaseProvider);
    _processOffer = ref.read(processOfferUsecaseProvider);
    _addDetail = ref.read(addOfferDetailUsecaseProvider);
    _updateDetail = ref.read(updateOfferDetailUsecaseProvider);
    _deleteDetail = ref.read(deleteOfferDetailUsecaseProvider);
    return OfferState();
  }

  /// Create offer for a post
  Future<bool> createOffer({
    required String postId,
    required CreateOfferRequestEntity request,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final result = await _createOffer(postId: postId, request: request);
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR CREATE OFFER: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: errorMsg);
      return false;
    }
  }

  /// Fetch offers by post
  Future<void> fetchOffersByPost({
    required String postId,
    String? status,
    required int page,
    required int size,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getOffersByPost(
        postId: postId,
        status: status,
        pageNumber: page,
        pageSize: size,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH OFFERS BY POST: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: errorMsg);
    }
  }

  /// Fetch all offers (for collector)
  Future<void> fetchAllOffers({
    String? status,
    bool? sortByCreateAtDesc,
    required int page,
    required int size,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getAllOffers(
        status: status,
        sortByCreateAtDesc: sortByCreateAtDesc,
        pageNumber: page,
        pageSize: size,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH ALL OFFERS: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: errorMsg);
    }
  }

  /// Fetch offer detail
  Future<void> fetchOfferDetail(String offerId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);

    try {
      final result = await _getOfferDetail(offerId);
      state = state.copyWith(isLoadingDetail: false, detailData: result);
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH OFFER DETAIL: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: errorMsg,
      );
    }
  }

  /// Toggle cancel offer (Pending <-> Canceled)
  Future<bool> toggleCancelOffer(String offerId) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _toggleCancel(offerId);
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR TOGGLE CANCEL OFFER: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: errorMsg);
      return false;
    }
  }

  /// Process offer (Accept/Reject)
  Future<bool> processOffer({
    required String offerId,
    required bool isAccepted,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _processOffer(
        offerId: offerId,
        isAccepted: isAccepted,
      );
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR PROCESS OFFER: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: errorMsg);
      return false;
    }
  }

  /// Add offer detail
  Future<bool> addOfferDetail({
    required String offerId,
    required int scrapCategoryId,
    required double pricePerUnit,
    required String unit,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final result = await _addDetail(
        offerId: offerId,
        scrapCategoryId: scrapCategoryId,
        pricePerUnit: pricePerUnit,
        unit: unit,
      );
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR ADD OFFER DETAIL: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: errorMsg);
      return false;
    }
  }

  /// Update offer detail
  Future<bool> updateOfferDetail({
    required String offerId,
    required String detailId,
    required double pricePerUnit,
    required String unit,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final result = await _updateDetail(
        offerId: offerId,
        detailId: detailId,
        pricePerUnit: pricePerUnit,
        unit: unit,
      );
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE OFFER DETAIL: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: errorMsg);
      return false;
    }
  }

  /// Delete offer detail
  Future<bool> deleteOfferDetail({
    required String offerId,
    required String detailId,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _deleteDetail(
        offerId: offerId,
        detailId: detailId,
      );
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR DELETE OFFER DETAIL: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: errorMsg);
      return false;
    }
  }
}
