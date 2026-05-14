import 'dart:convert';

import 'package:frontend/data/models/katalog_models.dart';
import 'package:frontend/core/constant/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/data/providers/storage_providers.dart';

class KatalogRepository {
  final StorageProviders storage = StorageProviders();

  Future<List<KatalogModels>> getAllKatalog() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}katalog'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KatalogModels.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data katalog");
    }
  }

  Future<KatalogModels> getKatalogById(int id) async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}katalog/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final Map<String, dynamic> data = body['data'];
      return KatalogModels.fromJson(data);
    } else {
      throw Exception("Gagal mengambil data katalog");
    }
  }

  Future<void> createKatalog(Map<String, dynamic> katalogData) async {
    final token = await storage.getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}katalog'),
    );
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    katalogData.forEach((key, value) {
      if (key != 'gambar' && value != null) {
        request.fields[key] = value.toString();
      }
    });

    if (katalogData['gambar'] != null &&
        katalogData['gambar'].toString().isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('gambar', katalogData['gambar']),
      );
    }
    print("MENGIRIM DATA: ${request.fields}");

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    print("BALASAN BACKEND: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menambahkan katalog';
    }
  }

  Future<void> updateKatlog(int id, Map<String, dynamic> katalogData) async {
    final token = await storage.getToken();

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}katalog/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(katalogData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal memperbarui katalog';
    }
  }

  Future<void> deleteKatalog(int id) async {
    final token = await storage.getToken();

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}katalog/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menghapus katalog';
    }
  }

  Future<List<KatalogModels>> getKatalogByKategori(int idKatkat) async {
    try {
      final semuaKatalog = await getAllKatalog();
      final filteredKatalog = await semuaKatalog.where((katalog) {
        return katalog.idKat == idKatkat;
      }).toList();

      return filteredKatalog;
    } catch (e) {
      throw Exception('Gagal mengambil data berdasarkan kategori: $e');
    }
  }
}
