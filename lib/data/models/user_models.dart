import 'package:equatable/equatable.dart';

class UserModels extends Equatable{
  final int id;
  final String nama;
  final String email;
  final String username;
  final String password;
  final String role;

  const UserModels({required this.id, required this.nama, required this.email, required this.username, required this.password, required this.role});

  factory UserModels.fromJson(Map<String, dynamic> json){
    return UserModels(
      id: json['id'], 
      nama: json['nama'] ??'', 
      email: json['email'] ?? '', 
      username: json['username'] ?? '', 
      password: json['password'] ?? '',
      role: json['role'] ?? ''
    );
  }
  @override
  List<Object?> get props => [id, nama, email, username, password, role];
}