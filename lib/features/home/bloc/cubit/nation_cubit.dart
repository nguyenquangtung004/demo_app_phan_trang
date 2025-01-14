// lib/features/home/bloc/cubit/nation_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/nation.dart';
import '../../../../domain/usecases/get_nation.dart';
import 'nation_state.dart'; // LINK: Import file state riêng biệt

/// SECTION: Cubit quản lý state và logic của quốc gia
class NationCubit extends Cubit<NationState> {
  // ANCHOR: Khai báo UseCase
  final GetNations getNations;

  /// SECTION: Constructor - Khởi tạo Cubit và gọi dữ liệu ban đầu
  NationCubit({required this.getNations}) : super(NationInitial()) {
    loadNations();
  }

  /// SECTION: Tải dữ liệu từ UseCase (Không chứa logic phân trang tại đây nữa)
  Future<void> loadNations() async {
    // NOTE: Kiểm tra nếu không còn dữ liệu từ use case
    if (!getNations.hasMoreData) {
      emit(NationError("Không còn dữ liệu để tải."));
      return;
    }

    // ANCHOR: Đẩy state loading (giữ lại dữ liệu cũ nếu có)
    emit(NationLoading(state is NationLoaded ? (state as NationLoaded).nations : []));

    try {
      // ANCHOR: Gọi Use Case để fetch dữ liệu
      final nations = await getNations.call();

      // ✅ Phát state thành công nếu có dữ liệu
      emit(NationLoaded(nations, hasMore: getNations.hasMoreData));
    } catch (e) {
      // ERROR: Xử lý lỗi và phát state lỗi
      emit(NationError('Lỗi khi tải dữ liệu: $e'));
    }
  }

  /// SECTION: Làm mới dữ liệu khi kéo xuống
  Future<void> resetPagination() async {
    getNations.resetPagination(); // Gọi reset từ UseCase
    emit(NationLoading([]));      // Phát loading state
    await loadNations();          // Gọi lại dữ liệu từ đầu
  }
}
