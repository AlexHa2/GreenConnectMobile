import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';

class ScrapPostState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final String? errorMessage;

  final PaginatedScrapPostEntity? listData;
  final ScrapPostEntity? detailData;

  ScrapPostState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.errorMessage,
    this.listData,
    this.detailData,
  });

  ScrapPostState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    String? errorMessage,
    PaginatedScrapPostEntity? listData,
    ScrapPostEntity? detailData,
  }) {
    return ScrapPostState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      errorMessage: errorMessage,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
    );
  }
}
