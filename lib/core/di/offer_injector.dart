import 'package:GreenConnectMobile/features/offer/data/datasources/offer_remote_datasource.dart';
import 'package:GreenConnectMobile/features/offer/data/datasources/offer_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/offer/data/repository/offer_repository_impl.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/add_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/create_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/delete_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_all_offers_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_offer_detail_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/get_offers_by_post_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/process_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/toggle_cancel_offer_usecase.dart';
import 'package:GreenConnectMobile/features/offer/domain/usecases/update_offer_detail_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initOfferModule() async {
  // DataSource
  sl.registerLazySingleton<OfferRemoteDataSource>(
    () => OfferRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<OfferRepository>(
    () => OfferRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => CreateOfferUsecase(sl()));
  sl.registerLazySingleton(() => GetOffersByPostUsecase(sl()));
  sl.registerLazySingleton(() => GetAllOffersUsecase(sl()));
  sl.registerLazySingleton(() => GetOfferDetailUsecase(sl()));
  sl.registerLazySingleton(() => ToggleCancelOfferUsecase(sl()));
  sl.registerLazySingleton(() => ProcessOfferUsecase(sl()));
  sl.registerLazySingleton(() => AddOfferDetailUsecase(sl()));
  sl.registerLazySingleton(() => UpdateOfferDetailUsecase(sl()));
  sl.registerLazySingleton(() => DeleteOfferDetailUsecase(sl()));
}
