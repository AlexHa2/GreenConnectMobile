import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

class ScrapCategoryState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final String? errorMessage;

  final PaginatedResponseEntity<ScrapCategoryEntity>? listData;
  final ScrapCategoryEntity? detailData;

  ScrapCategoryState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.errorMessage,
    this.listData,
    this.detailData,
  });

  ScrapCategoryState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    String? errorMessage,
    PaginatedResponseEntity<ScrapCategoryEntity>? listData,
    ScrapCategoryEntity? detailData,
  }) {
    return ScrapCategoryState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      errorMessage: errorMessage,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
    );
  }
}
