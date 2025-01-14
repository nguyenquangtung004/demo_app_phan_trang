// SECTION: Định nghĩa các trạng thái cho NationCubit
import '../../../../domain/entities/nation.dart';

/// SECTION: Abstract Class NationState - Tất cả các trạng thái đều kế thừa từ đây
abstract class NationState {
  NationState() {
    print('📦 [NationState] Trạng thái khởi tạo: ${runtimeType.toString()}');
  }
}

/// ANCHOR: Trạng thái khởi tạo ban đầu
class NationInitial extends NationState {
  final List<NationEntity> nations;
  NationInitial({this.nations = const []}) : super() {
    print('🔄 [NationState] Khởi tạo NationInitial với ${nations.length} quốc gia');
  }
}

/// ANCHOR: Trạng thái loading khi đang tải dữ liệu
class NationLoading extends NationState {
  NationLoading() : super() {
    print('⏳ [NationState] Đang tải dữ liệu...');
  }
}

/// ANCHOR: Trạng thái khi dữ liệu đã tải thành công
class NationLoaded extends NationState {
  final List<NationEntity> nations;
  NationLoaded(this.nations) : super() {
    print('✅ [NationState] Dữ liệu tải thành công với ${nations.length} quốc gia');
  }
}

/// ANCHOR: Trạng thái lỗi khi không tải được dữ liệu
class NationError extends NationState {
  final String message;
  NationError(this.message) : super() {
    print('❌ [NationState] Lỗi xảy ra: $message');
  }
}
