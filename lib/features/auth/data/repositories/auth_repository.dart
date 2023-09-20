import 'package:firebase_auth/firebase_auth.dart';

import '../entity/auth_entity.dart';

class AuthRepository {
  Future<void> signUp({required AuthEntity authEntity}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: authEntity.userName, password: authEntity.password);
    } on FirebaseAuthException catch (e) {
      //Se evalúan los resultados del método de firebase, en caso de error
      if (e.code == 'weak-password') {
        throw Exception('La password asignada es demasiado débil');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Ya existe una cuenta con este email');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> signIn({required AuthEntity authEntity}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: authEntity.userName, password: authEntity.password);
      return true;
    } on FirebaseAuthException catch (e) {
      //Se evalúan los resultados del método de firebase, en caso de error
      if (e.code == 'user-not-found') {
        //Se envia el mismo mensaje por seguridad, dado que no es recomendable
        //especificar si el problema está en el email o en la password de manera particular
        throw Exception('Usuario o password no son correctas');
      } else if (e.code == 'wrong-password') {
        throw Exception('Usuario o password no son correctas');
      }
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
