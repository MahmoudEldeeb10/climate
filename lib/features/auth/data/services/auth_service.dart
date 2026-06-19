import 'package:dio/dio.dart';
import '../models/auth_response_model.dart';

/// استثناء مخصص بيحمل رسالة الـ API نفسها (مثل "Invalid email address.")
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  static const String _baseUrl =
      'https://weatherauthapi-production.up.railway.app/api/Auth';

  Future<AuthResponseModel> register({
    required String email,
    required String password,
  }) {
    return _post('$_baseUrl/register', {
      'email': email,
      'password': password,
    });
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) {
    return _post('$_baseUrl/login', {
      'email': email,
      'password': password,
    });
  }

  Future<AuthResponseModel> forgotPassword({
    required String email,
  }) {
    return _post('$_baseUrl/forgot-password', {
      'email': email,
    });
  }

  Future<AuthResponseModel> _post(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await dio.post(url, data: body);
      return AuthResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        throw AuthException(data['message'].toString());
      }
      throw AuthException('تأكدي من اتصال الإنترنت وحاولي تاني');
    }
  }
}