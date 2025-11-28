import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_categories_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_category_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/viewmodels/states/scrap_category_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrapCategoryViewModel extends Notifier<ScrapCategoryState> {
  late GetScrapCategoriesUseCase _getScrapCategoriesUseCase;
  late GetScrapCategoryDetailUseCase _getScrapCategoryDetailUseCase;

  @override
  ScrapCategoryState build() {
    _getScrapCategoriesUseCase = ref.read(getScrapCategoriesUsecaseProvider);
    _getScrapCategoryDetailUseCase = ref.read(
      getScrapCategoryDetailUsecaseProvider,
    );

    return ScrapCategoryState();
  }

  // Fetch List
  Future<void> fetchScrapCategories({
    required int pageNumber,
    required int pageSize,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getScrapCategoriesUseCase(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e) {
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  // Fetch Detail
  Future<void> fetchScrapCategoryDetail(int id) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);

    try {
      final result = await _getScrapCategoryDetailUseCase(id);
      state = state.copyWith(isLoadingDetail: false, detailData: result);
    } catch (e) {
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Reset
  void reset() {
    state = ScrapCategoryState();
  }
}
