// lib/data/data_source/nation_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../core/error/error.dart';
import '../models/nation_model.dart';

/// SECTION: NationRemoteDataSource
/// NOTE: Class chịu trách nhiệm gọi API và xử lý dữ liệu thô từ server.
class NationRemoteDataSource {
  // ANCHOR: Khai báo đối tượng Dio để gọi API
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://restcountries.com/v3.1',
      connectTimeout: Duration(seconds: 120),
      receiveTimeout: Duration(seconds: 120),
    ),
  );

  /// SECTION: Constructor - Thêm interceptor để xử lý lỗi và retry request
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

  /// SECTION: Fetch danh sách quốc gia từ API
  /// - offset: Phân trang, vị trí bắt đầu
  /// - limit: Giới hạn số lượng phần tử cần lấy
  Future<List<NationModel>> fetchNations({int offset = 0, int limit = 10}) async {
    try {
      print('🔗 [DataSource] Đang gọi API để lọc quốc gia với offset: $offset và limit: $limit...');
      
      // ANCHOR: Gọi API lấy dữ liệu quốc gia
      final response = await _dio.get('/all?fields=name,flags');

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

        // ANCHOR: Chuyển đổi từ JSON sang NationModel
        return paginatedData.map((nation) => NationModel.fromJson(nation)).toList();
      } else {
        // ERROR: Nếu lỗi từ HTTP
        throw _handleHttpError(response.statusCode);
      }
    } catch (error) {
      // ERROR: Xử lý lỗi chung từ Dio và ném ra lỗi cụ thể
      print('❌ [DataSource] Lỗi khi fetch dữ liệu từ server: $error');
      throw _mapDioError(error as DioException);
    }
  }

  /// SECTION: Xử lý lỗi HTTP từ server (400, 404, 500)
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

  /// SECTION: Xử lý lỗi DioException (lỗi kết nối mạng và timeout)
  Exception _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Kết nối đến server quá lâu');
      case DioExceptionType.receiveTimeout:
        return NetworkException('Server phản hồi quá lâu');
      case DioExceptionType.badResponse:
        return BadRequestException('Phản hồi không hợp lệ từ server');
      default:
        return UnknownException('Lỗi không xác định: ${error.message}');
    }
  }
}
