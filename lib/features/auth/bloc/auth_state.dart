import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../data/entity/auth_entity.dart';

@immutable
abstract class AuthState extends Equatable {}

class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {
  final AuthEntity authEntity;
  UnAuthenticated(this.authEntity);
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
  @override
  List<Object?> get props => [error];
}
