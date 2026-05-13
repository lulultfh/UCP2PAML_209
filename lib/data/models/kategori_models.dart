import 'package:equatable/equatable.dart';

class KategoriModels extends Equatable {
  final int id;
  final String nama;

  const KategoriModels({required this.id, required this.nama});

  factory KategoriModels.fromJson(Map<String, dynamic> json) {
    return KategoriModels(id: json['id'], nama: json['nama'] ?? '');
  }
  @override
  List<Object?> get props => [id, nama];
}
