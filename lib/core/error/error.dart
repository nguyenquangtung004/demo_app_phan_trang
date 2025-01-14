// Lớp cơ sở cho tất cả các lỗi trong ứng dụng
abstract class AppError implements Exception {
  final String message;
  final String? code;

  AppError(this.message, {this.code});

  @override
  String toString() => 'Error[$code]: $message';
}

// SECTION: Network Errors - Các lỗi liên quan đến mạng
class NetworkError extends AppError {
  NetworkError(String message, {String? code}) : super(message, code: code);
}

class NoInternetError extends NetworkError {
  NoInternetError() : super('Không có kết nối internet', code: 'NO_INTERNET');
}

class ServerError extends NetworkError {
  ServerError([String? message])
      : super(message ?? 'Lỗi máy chủ', code: 'SERVER_ERROR');
}

class TimeoutError extends NetworkError {
  TimeoutError() : super('Yêu cầu quá thời gian', code: 'TIMEOUT');
}

// SECTION: Authentication Errors - Các lỗi xác thực
class AuthError extends AppError {
  AuthError(String message, {String? code}) : super(message, code: code);
}

class InvalidCredentialsError extends AuthError {
  InvalidCredentialsError()
      : super('Tên đăng nhập hoặc mật khẩu không đúng',
            code: 'INVALID_CREDENTIALS');
}

class UnauthorizedError extends AuthError {
  UnauthorizedError()
      : super('Bạn không có quyền truy cập', code: 'UNAUTHORIZED');
}

class SessionExpiredError extends AuthError {
  SessionExpiredError()
      : super('Phiên đăng nhập đã hết hạn', code: 'SESSION_EXPIRED');
}

// SECTION: Data Errors - Các lỗi liên quan đến dữ liệu
class DataError extends AppError {
  DataError(String message, {String? code}) : super(message, code: code);
}

class InvalidDataError extends DataError {
  InvalidDataError([String? message])
      : super(message ?? 'Dữ liệu không hợp lệ', code: 'INVALID_DATA');
}

class NotFoundError extends DataError {
  NotFoundError([String? resource])
      : super('Không tìm thấy ${resource ?? 'dữ liệu'}', code: 'NOT_FOUND');
}

class DuplicateError extends DataError {
  DuplicateError([String? resource])
      : super('${resource ?? 'Dữ liệu'} đã tồn tại', code: 'DUPLICATE');
}

// SECTION: Input Validation Errors - Các lỗi validate đầu vào
class ValidationError extends AppError {
  final Map<String, String>? errors;

  ValidationError(String message, {this.errors, String? code})
      : super(message, code: code ?? 'VALIDATION_ERROR');
}

class RequiredFieldError extends ValidationError {
  RequiredFieldError(String fieldName)
      : super('$fieldName là bắt buộc', code: 'REQUIRED_FIELD');
}

class InvalidFormatError extends ValidationError {
  InvalidFormatError(String fieldName, String format)
      : super('$fieldName không đúng định dạng $format',
            code: 'INVALID_FORMAT');
}

// SECTION: File Errors - Các lỗi liên quan đến file
class FileError extends AppError {
  FileError(String message, {String? code}) : super(message, code: code);
}

class FileNotFoundError extends FileError {
  FileNotFoundError([String? path])
      : super('Không tìm thấy file${path != null ? ' tại $path' : ''}',
            code: 'FILE_NOT_FOUND');
}

class FileSizeError extends FileError {
  FileSizeError([int? maxSize])
      : super(
            'Kích thước file quá lớn${maxSize != null ? ' (tối đa ${maxSize}MB)' : ''}',
            code: 'FILE_SIZE_ERROR');
}

class FileTypeError extends FileError {
  FileTypeError([List<String>? allowedTypes])
      : super(
            'Định dạng file không được hỗ trợ${allowedTypes?.isNotEmpty == true ? ' (cho phép: ${allowedTypes?.join(', ')})' : ''}',
            code: 'FILE_TYPE_ERROR');
}

// SECTION: Định nghĩa các Exception chi tiết theo lỗi server
class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class ServerErrorException implements Exception {
  final String message;
  ServerErrorException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class CancelException implements Exception {
  final String message;
  CancelException(this.message);
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);
}

