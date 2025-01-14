// lib/domain/usecases/get_nation.dart

/// SECTION: Import các thư viện và định nghĩa use case
import 'package:demo_app/domain/entities/nation.dart';
import '../repository/nation_repository.dart';

/// SECTION: Use Case GetNations
/// NOTE: Nhiệm vụ chính là gọi repository để lấy danh sách quốc gia

class GetNations {
  // ANCHOR: Khai báo repository và thuộc tính phân trang
  final NationRepository repository;

  int _offset = 0;
  final int _limit = 5;
  bool _hasMore = true;

  // SECTION: Constructor - Inject repository từ bên ngoài (Dependency Injection)
  GetNations({required this.repository});

  // SECTION: Phương thức call để gọi use case với phân trang
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
      // NOTE: Tăng giá trị offset sau mỗi lần fetch dữ liệu.
      _offset += nations.length;
      //NOTE: Nếu số lượng dữ liệu trả về nhỏ hơn _limit, đánh dấu hết dữ liệu (_hasMore = false).
      //NOTE: Nếu đúng bằng _limit, có thể còn dữ liệu để tải (_hasMore = true).
      _hasMore = nations.length == _limit;

      return nations;
    } catch (e) {
      // ERROR: Xử lý lỗi chi tiết
      print('❌ [GetNations] Lỗi khi gọi repository: $e');
      throw Exception('Lỗi khi gọi repository: $e');
    }
  }

  // SECTION: Reset phân trang khi làm mới dữ liệu
  void resetPagination() {
    _offset = 0;
    _hasMore = true;
    print('🔄 [GetNations] Reset phân trang về giá trị ban đầu.');
  }

  //NOTE: ✅ Getter kiểm tra còn dữ liệu hay không
  bool get hasMoreData => _hasMore;
}
