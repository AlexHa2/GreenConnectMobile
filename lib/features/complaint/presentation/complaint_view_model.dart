import 'package:GreenConnectMobile/features/complaint/domain/entities/create_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/update_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/create_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/get_all_complaints_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/get_complaint_detail_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/process_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/reopen_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/update_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/complaint_providers.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/complaint_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComplaintViewModel extends Notifier<ComplaintState> {
  late GetAllComplaintsUsecase _getAllComplaints;
  late GetComplaintDetailUsecase _getComplaintDetail;
  late CreateComplaintUsecase _createComplaint;
  late UpdateComplaintUsecase _updateComplaint;
  late ProcessComplaintUsecase _processComplaint;
  late ReopenComplaintUsecase _reopenComplaint;

  @override
  ComplaintState build() {
    _getAllComplaints = ref.read(getAllComplaintsUsecaseProvider);
    _getComplaintDetail = ref.read(getComplaintDetailUsecaseProvider);
    _createComplaint = ref.read(createComplaintUsecaseProvider);
    _updateComplaint = ref.read(updateComplaintUsecaseProvider);
    _processComplaint = ref.read(processComplaintUsecaseProvider);
    _reopenComplaint = ref.read(reopenComplaintUsecaseProvider);
    return ComplaintState();
  }

  /// Fetch all complaints with optional filters and pagination
  Future<void> fetchAllComplaints({
    int? pageNumber,
    int? pageSize,
    bool? sortByCreatedAt,
    String? sortByStatus,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);
    try {
      final result = await _getAllComplaints(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortByCreatedAt: sortByCreatedAt,
        sortByStatus: sortByStatus,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      debugPrint('❌ ERROR in fetchAllComplaints: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isLoadingList: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Fetch single complaint detail
  Future<void> fetchComplaintDetail(String complaintId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      final result = await _getComplaintDetail(complaintId);
      state = state.copyWith(isLoadingDetail: false, detailData: result);
    } catch (e, stack) {
      debugPrint('❌ ERROR in fetchComplaintDetail: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Create a new complaint
  Future<bool> createComplaint({
    required String transactionId,
    required String reason,
    required String evidenceUrl,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      final request = CreateComplaintRequest(
        transactionId: transactionId,
        reason: reason,
        evidenceUrl: evidenceUrl,
      );
      final result = await _createComplaint(request);
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      debugPrint('❌ ERROR in createComplaint: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update existing complaint (only when status is Pending)
  Future<bool> updateComplaint({
    required String complaintId,
    String? reason,
    String? evidenceUrl,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      final request = UpdateComplaintRequest(
        reason: reason,
        evidenceUrl: evidenceUrl,
      );
      final result = await _updateComplaint(
        complaintId: complaintId,
        request: request,
      );
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      debugPrint('❌ ERROR in updateComplaint: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Process complaint (Admin only - Accept or Reject)
  Future<bool> processComplaint({
    required String complaintId,
    required bool isAccept,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      final success = await _processComplaint(
        complaintId: complaintId,
        isAccept: isAccept,
      );
      state = state.copyWith(isProcessing: false);
      if (success) {
        // Refresh detail to get updated status
        await fetchComplaintDetail(complaintId);
      }
      return success;
    } catch (e, stack) {
      debugPrint('❌ ERROR in processComplaint: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Reopen a rejected/closed complaint
  Future<bool> reopenComplaint(String complaintId) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      final result = await _reopenComplaint(complaintId);
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      debugPrint('❌ ERROR in reopenComplaint: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
