import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/data/models/user_models.dart';
import 'dart:developer' as developer;

class AuthRepository {
  final _storage = const FlutterSecureStorage();

  Future<void> persistToken(String token) async{
    await _storage.write(key: 'jwt_token', value: token);
  }
  Future<String?> getToken() async{
    return await _storage.read(key: 'jwt_token');
  }
  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<UserModels> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );
      final data = jsonDecode(response.body);
      developer.log('Response Login: ${response.body}', name: 'API');

      if (response.statusCode == 200) {
        await persistToken(data['token']);
        return UserModels.fromJson(data['user']);
      } else {
        throw data['message'] ?? 'Gagal Login';
      }
    } catch (e) {
      developer.log('Error pada Login: $e', name: 'API');
      rethrow;
    }
  }

  Future<void> register({
    required String nama,
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      developer.log('Response Register API (${response.statusCode}): ${response.body}', name: 'API');
      final responseData = jsonDecode(response.body);

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw responseData['message'] ?? 'Gagal Register';
      }
    } catch (e) {
      developer.log('Error pada Register: $e', name: 'API');
      rethrow;
    }
  }
}