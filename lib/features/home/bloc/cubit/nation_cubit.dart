import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/nation.dart';
import '../../../../domain/usecases/get_nation.dart';

abstract class NationState {}

class NationInitial extends NationState {}

class NationLoading extends NationState {
  final List<NationEntity> nations;
  NationLoading(this.nations);
}

class NationLoaded extends NationState {
  final List<NationEntity> nations;
  final bool hasMore;
  NationLoaded(this.nations, {this.hasMore = true});
}

class NationError extends NationState {
  final String message;
  NationError(this.message);
}

class NationCubit extends Cubit<NationState> {
  final GetNations getNations;
  int _offset = 0;
  final int _limit = 5;
  bool _hasMore = true;

  NationCubit({required this.getNations}) : super(NationInitial()) {
    loadNations();
  }

  /// ✅ Tải dữ liệu phân trang
  Future<void> loadNations() async {
    if (!_hasMore) return;
    emit(NationLoading(state is NationLoaded ? (state as NationLoaded).nations : []));

    try {
      final nations = await getNations(offset: _offset, limit: _limit);
      _offset += nations.length;
      _hasMore = nations.length == _limit;

      final updatedNations = [
        if (state is NationLoaded) ...(state as NationLoaded).nations,
        ...nations
      ];

      emit(NationLoaded(updatedNations, hasMore: _hasMore));
    } catch (e) {
      emit(NationError('Lỗi khi tải dữ liệu: $e'));
    }
  }

  /// ✅ Làm mới dữ liệu khi kéo xuống
  Future<void> resetPagination() async {
    _offset = 0;
    _hasMore = true;
    emit(NationLoading([]));
    await loadNations();
  }
}
