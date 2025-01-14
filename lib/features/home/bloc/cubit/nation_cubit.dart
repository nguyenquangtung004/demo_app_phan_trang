import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_nation.dart';
import '../../../../domain/entities/nation.dart';

abstract class NationState {}

class NationInitial extends NationState {}
class NationLoading extends NationState {}
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
  final int _limit = 53;
  bool _hasMore = true;

  NationCubit({required this.getNations}) : super(NationInitial()) {
    loadNations();
  }

 Future<void> loadNations() async {
  emit(NationLoading());
  try {
    final nations = await getNations(offset: _offset, limit: _limit);
    _offset += nations.length;
    emit(NationLoaded(nations));
  } catch (e) {
    print('❌ [Cubit] Lỗi: $e');
    emit(NationError('Lỗi khi tải dữ liệu: $e'));
  }
}


  void resetPagination() {
    _offset = 0;
    _hasMore = true;
    loadNations();
  }
}
