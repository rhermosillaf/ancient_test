import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class EmailTextChanged extends AuthEvent {
  final String emailText;
  EmailTextChanged(this.emailText);
}

class PasswordTextChanged extends AuthEvent {
  final String passwordText;
  PasswordTextChanged(this.passwordText);
}
