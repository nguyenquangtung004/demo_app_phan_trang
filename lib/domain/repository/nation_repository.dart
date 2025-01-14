// lib/domain/repository/nation_repository.dart

import '../entities/nation.dart';

/// SECTION: Interface NationRepository
/// NOTE: Interface định nghĩa các phương thức cần thiết cho repository.
abstract class NationRepository {
  /// ANCHOR: Lấy danh sách các quốc gia (với phân trang)
  /// - offset: Vị trí bắt đầu phân trang.
  /// - limit: Số lượng item tối đa cần lấy.
  /// - Return: Danh sách các đối tượng `NationEntity`.
  Future<List<NationEntity>> getNations({int offset = 0, int limit = 5});
}
