// SECTION: Import các thư viện và định nghĩa use case
import 'package:demo_app/domain/entities/nation.dart';
import '../repository/nation_repository.dart';

/// SECTION: Use Case GetNations
/// NOTE: Nhiệm vụ chính là gọi repository để lấy danh sách quốc gia

class GetNations {
  // ANCHOR: Khai báo NationRepository sử dụng Dependency Injection
  final NationRepository repository;

  // SECTION: Khởi tạo đối tượng GetNations với repository
  // NOTE: Inject repository từ bên ngoài để dễ dàng mock và kiểm thử
  GetNations({required this.repository});

  // SECTION: Phương thức call để gọi use case với logging chi tiết
  // NOTE: offset và limit dùng để phân trang
  Future<List<NationEntity>> call({int offset = 0, int limit = 10}) async {
    print('🔄 [GetNations] Gọi use case với offset: $offset, limit: $limit');
    try {
      // ANCHOR: Gọi repository để lấy dữ liệu
      final nations = await repository.getNations(offset: offset, limit: limit);
      print('✅ [GetNations] Dữ liệu lấy thành công. Số lượng: ${nations.length}');
      return nations;
    } catch (e) {
      // ERROR: Nếu lỗi, ném ngoại lệ để xử lý bên ngoài
      print('❌ [GetNations] Lỗi khi lấy danh sách quốc gia: $e');
      throw Exception('Lỗi khi lấy danh sách quốc gia: $e');
    }
  }
}
