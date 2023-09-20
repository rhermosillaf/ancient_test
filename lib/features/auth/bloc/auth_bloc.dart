import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/entity/auth_entity.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  static AuthEntity authEntity = AuthEntity("", "");
  AuthBloc({required this.authRepository})
      : super(UnAuthenticated(authEntity)) {
    //Al presionr el botpon ingresar, se llama al método signIn del repositorio
    // y ejecutar el método de ingreso de firebase
    on<SignInRequested>((event, emit) async {
      emit(Loading());

      try {
        await authRepository.signIn(authEntity: authEntity);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated(authEntity));
      }
    });

    //al presionar botón <Registrar>
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUp(authEntity: authEntity);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated(authEntity));
      }
    });

    //Al presionar el boton <Salir> enviamos el evento SgnOutRequested, el cual ejecuta el método signOut del respositorio de Firebase y emite nuevo estado UnAuthenticated
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.signOut();
      emit(UnAuthenticated(authEntity));
    });

    //Al ingresar o modificar el campo de email, se asigna el valor al campo userName de la entidad AuthEntity y se emite el estado UnAuthenticated con el fin de mantener el widget construido
    on<EmailTextChanged>((event, emit) {
      authEntity.userName = event.emailText;
      if (!authEntity.isValidForm()) {
        emit(UnAuthenticated(authEntity));
      }
    });

    //Al ingresar o modificar el campo de password, se asigna el valor al campo userName de la entidad AuthEntity y se emite el estado UnAuthenticated con el fin de mantener el widget construido
    on<PasswordTextChanged>((event, emit) {
      authEntity.password = event.passwordText;
      if (!authEntity.isValidForm()) {
        emit(UnAuthenticated(authEntity));
      }
    });
  }
}
