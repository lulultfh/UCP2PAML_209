import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username, password;
  
  LoginRequested({required this.username,required this.password});
  @override
  List<Object> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String nama, email, username, password, role;
  RegisterRequested({required this.nama, required this.email, required  this.username,required this.password, required this.role});

  @override
  List<Object> get props => [nama, email, username, password, role];
}

class LogoutRequested extends AuthEvent {}