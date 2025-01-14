// lib/features/home/bloc/cubit/nation_state.dart

import '../../../../domain/entities/nation.dart';

/// SECTION: Định nghĩa các trạng thái (State)
/// NOTE: Các state đại diện cho trạng thái khác nhau của NationCubit
abstract class NationState {}

/// ANCHOR: Trạng thái khởi tạo ban đầu
class NationInitial extends NationState {}

/// ANCHOR: Trạng thái đang tải dữ liệu
class NationLoading extends NationState {
  final List<NationEntity> nations; // Giữ lại dữ liệu cũ nếu có
  NationLoading(this.nations);
}

/// ANCHOR: Trạng thái đã tải dữ liệu thành công
class NationLoaded extends NationState {
  final List<NationEntity> nations;
  final bool hasMore;
  NationLoaded(this.nations, {this.hasMore = true});
}

/// ANCHOR: Trạng thái lỗi khi tải dữ liệu
class NationError extends NationState {
  final String message;
  NationError(this.message);
}
