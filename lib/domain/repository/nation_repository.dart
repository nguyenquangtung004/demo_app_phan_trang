import '../entities/nation.dart';

/// SECTION: Định nghĩa contract cho Nation Repository
abstract class NationRepository {
  /// SECTION: Lấy danh sách các quốc gia (theo phân trang) với logging
  Future<List<NationEntity>> getNations({int offset = 0, int limit = 10}) {
    print('🔄 [NationRepository] Gọi phương thức getNations với offset: $offset, limit: $limit');
    throw UnimplementedError('Phương thức getNations chưa được triển khai');
  }
}
