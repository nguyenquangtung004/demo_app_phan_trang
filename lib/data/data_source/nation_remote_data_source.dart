import 'package:dio/dio.dart';
import '../../core/error/error.dart';
import '../models/nation_model.dart';

class NationRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://restcountries.com/v3.1',
      connectTimeout: Duration(seconds: 120),
      receiveTimeout: Duration(seconds: 120),
    ),
  );

  NationRemoteDataSource() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, handler) async {
        if (error.type == DioExceptionType.connectionTimeout) {
          print('🕰️ Timeout xảy ra, thử lại sau 5 giây...');
          await Future.delayed(Duration(seconds: 5));
          return handler.next(error);
        }
        return handler.reject(error);
      },
    ));
  }

  /// Fetch các quốc gia có chữ "B" và hỗ trợ phân trang (offset + limit)
  Future<List<NationModel>> fetchNations({int offset = 0, int limit = 10}) async {
    try {
      print('🔗 [DataSource] Đang gọi API để lọc quốc gia có chữ "B" với offset: $offset và limit: $limit...');
      
      // Gọi API chỉ lấy tên và cờ
      final response = await _dio.get('/all?fields=name,flags');
      // final response = await _dio.get('/region/europe?fields=name,flags');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // ✅ Lọc các quốc gia có chứa chữ "B"
        final filteredData = data.where((nation) {
          final name = nation['name']['common'].toString().toLowerCase();
          return name.contains('b');
        }).toList();

        // ✅ Phân trang dựa trên offset và limit
        if (offset >= filteredData.length) {
          print('⚠️ [DataSource] Offset vượt quá tổng số quốc gia');
          return [];
        }

        final paginatedData = filteredData.skip(offset).take(limit).toList();
        print('✅ [DataSource] Dữ liệu lọc & phân trang: ${paginatedData.length} quốc gia.');

        // ✅ Chuyển đổi từ JSON sang NationModel
        return paginatedData.map((nation) => NationModel.fromJson(nation)).toList();
      } else {
        throw Exception('❌ [DataSource] HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [DataSource] Lỗi khi fetch dữ liệu từ server: $e');
      throw Exception('Lỗi khi lấy dữ liệu từ server: $e');
    }
  }

  /// Xử lý lỗi HTTP
  Exception _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return BadRequestException('Yêu cầu không hợp lệ');
      case 404:
        return NotFoundException('Không tìm thấy dữ liệu');
      case 500:
        return ServerErrorException('Lỗi máy chủ');
      default:
        return UnknownException('Lỗi không xác định: $statusCode');
    }
  }

  /// Xử lý lỗi DioException
  Exception _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Kết nối đến server quá lâu');
      case DioExceptionType.receiveTimeout:
        return NetworkException('Server phản hồi quá lâu');
      default:
        return UnknownException('Lỗi không xác định: ${error.message}');
    }
  }
}
