// lib/domain/usecases/get_nation.dart

/// SECTION: Import các thư viện và định nghĩa use case
import 'package:demo_app/domain/entities/nation.dart';
import '../repository/nation_repository.dart';

/// SECTION: Use Case GetNations
/// NOTE: Nhiệm vụ chính là gọi repository để lấy danh sách quốc gia

class GetNations {
  // ANCHOR: Khai báo repository và thuộc tính phân trang
  final NationRepository repository;

  /// ✅ Tách biệt logic phân trang (Clean hơn)
  int _offset = 0;
  final int _limit = 5;
  bool _hasMore = true;

  /// SECTION: Constructor - Inject repository từ bên ngoài (Dependency Injection)
  GetNations({required this.repository});

  /// SECTION: Phương thức call để gọi use case với phân trang
  Future<List<NationEntity>> call() async {
    if (!_hasMore) {
      print('⚠️ [GetNations] Không còn dữ liệu để tải.');
      return [];
    }

    print('🔄 [GetNations] Gọi use case với offset: $_offset, limit: $_limit');
    try {
      // ANCHOR: Gọi repository để lấy dữ liệu
      final nations = await repository.getNations(offset: _offset, limit: _limit);
      print('✅ [GetNations] Dữ liệu lấy thành công. Số lượng: ${nations.length}');

      // ANCHOR: Cập nhật offset và kiểm tra còn dữ liệu không
      _offset += nations.length;
      _hasMore = nations.length == _limit;

      return nations;
    } catch (e) {
      // ERROR: Xử lý lỗi chi tiết
      print('❌ [GetNations] Lỗi khi gọi repository: $e');
      throw Exception('Lỗi khi gọi repository: $e');
    }
  }

  /// SECTION: Reset phân trang khi làm mới dữ liệu
  void resetPagination() {
    _offset = 0;
    _hasMore = true;
    print('🔄 [GetNations] Reset phân trang về giá trị ban đầu.');
  }

  /// ✅ Getter kiểm tra còn dữ liệu hay không
  bool get hasMoreData => _hasMore;
}
