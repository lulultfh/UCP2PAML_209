import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username, password;
  LoginRequested(this.username, this.password);
}

class RegisterRequested extends AuthEvent {
  final String nama, email, username, password, role;
  RegisterRequested(this.nama, this.email,  this.username,this.password,  this.role);
}

class LogoutRequested extends AuthEvent {}