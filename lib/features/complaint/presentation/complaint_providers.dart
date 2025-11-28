import 'package:GreenConnectMobile/features/complaint/data/datasources/complaint_remote_datasource.dart';
import 'package:GreenConnectMobile/features/complaint/data/datasources/complaint_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/complaint/data/repositories/complaint_repository_impl.dart';
import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/create_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/get_all_complaints_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/get_complaint_detail_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/process_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/reopen_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/domain/usecases/update_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/complaint_state.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/complaint_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Datasource Provider
final complaintRemoteDsProvider = Provider<ComplaintRemoteDatasource>((ref) {
  return ComplaintRemoteDatasourceImpl();
});

// Repository Provider
final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) {
  return ComplaintRepositoryImpl(ref.read(complaintRemoteDsProvider));
});

// Use Case Providers
final getAllComplaintsUsecaseProvider = Provider<GetAllComplaintsUsecase>((ref) {
  return GetAllComplaintsUsecase(ref.read(complaintRepositoryProvider));
});

final getComplaintDetailUsecaseProvider =
    Provider<GetComplaintDetailUsecase>((ref) {
  return GetComplaintDetailUsecase(ref.read(complaintRepositoryProvider));
});

final createComplaintUsecaseProvider = Provider<CreateComplaintUsecase>((ref) {
  return CreateComplaintUsecase(ref.read(complaintRepositoryProvider));
});

final updateComplaintUsecaseProvider = Provider<UpdateComplaintUsecase>((ref) {
  return UpdateComplaintUsecase(ref.read(complaintRepositoryProvider));
});

final processComplaintUsecaseProvider =
    Provider<ProcessComplaintUsecase>((ref) {
  return ProcessComplaintUsecase(ref.read(complaintRepositoryProvider));
});

final reopenComplaintUsecaseProvider = Provider<ReopenComplaintUsecase>((ref) {
  return ReopenComplaintUsecase(ref.read(complaintRepositoryProvider));
});

// ViewModel Provider
final complaintViewModelProvider =
    NotifierProvider<ComplaintViewModel, ComplaintState>(() {
  return ComplaintViewModel();
});
