// SECTION: Import các thư viện cần thiết và định nghĩa repository implementation
import '../../domain/entities/nation.dart';
import '../../domain/repository/nation_repository.dart';
import '../data_source/nation_remote_data_source.dart';

/// SECTION: Triển khai NationRepository - NationRepositoryImpl
/// - Trách nhiệm: Thực hiện việc lấy dữ liệu từ remote data source
class NationRepositoryImpl implements NationRepository {
  // ANCHOR: Khai báo remote data source
  final NationRemoteDataSource remoteDataSource;

  /// SECTION: Constructor - Nhận vào remote data source thông qua DI
  NationRepositoryImpl({required this.remoteDataSource});

  /// SECTION: Triển khai phương thức getNations từ interface NationRepository
  /// - Chỉ tập trung vào việc gọi data source và ánh xạ dữ liệu
  @override
  Future<List<NationEntity>> getNations({int offset = 0, int limit = 10}) async {
    try {
      // ANCHOR: Lấy dữ liệu từ remote data source
      final models = await remoteDataSource.fetchNations(offset: offset, limit: limit);
      // ANCHOR: Chuyển đổi từ Model sang Entity (Chuyển đổi tầng Data sang Domain)
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // ERROR: Xử lý khi có lỗi xảy ra trong quá trình fetch dữ liệu
      throw Exception('Lỗi khi lấy dữ liệu quốc gia từ remote data source: $e');
    }
  }
}
