import 'dart:convert';

import 'package:frontend/data/models/kategori_models.dart';
import 'package:frontend/core/constant/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/data/providers/storage_providers.dart';

class KategoriRepositori {
  final StorageProviders storage = StorageProviders();

  Future<List<KategoriModels>> getAllKategori() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}kategori'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KategoriModels.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data kategori");
    }
  }

  Future<void> createKategori(Map<String, dynamic> kategoriData) async{
    final token = await storage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}kategori'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(kategoriData)
    );
    
    if(response.statusCode != 201 && response.statusCode != 200){
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menambahkan kategori';
    }
  }
  
  Future<void> updateKategori(int id, Map<String, dynamic> kategoriData) async{
    final token = await storage.getToken();

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}kategori/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(kategoriData)
    );
    
    if(response.statusCode != 201 && response.statusCode != 200){
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal memperbarui kategori';
    }
  }

  Future<void> deleteKategori(int id) async{
    final token = await storage.getToken();

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}kategori/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    
    if(response.statusCode != 201 && response.statusCode != 200){
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menghapus kategori';
    }
  }
}
