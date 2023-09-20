import 'package:ancient/features/auth/data/entity/auth_entity.dart';
import 'package:ancient/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFireBaseAuth extends Mock implements FirebaseAuth {
  void main() {
    AuthEntity authEntity = AuthEntity("roberto@roberto.cl", "123456");
    //MockFireBaseAuth auth = MockFireBaseAuth();

    test("Ingresando con email y password", () async {
      expect(await AuthRepository().signIn(authEntity: authEntity), false);
    });
  }
}
