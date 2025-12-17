import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/pagination_entity.dart';

class PackageListResponseEntity {
  final List<PackageEntity> data;
  final PaginationEntity pagination;

  PackageListResponseEntity({
    required this.data,
    required this.pagination,
  });
}
