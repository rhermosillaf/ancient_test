import 'package:flutter_test/flutter_test.dart';
import 'package:email_validator/email_validator.dart';

void main() {
  test("Validamos email con la función de package", () {
    expect(
      EmailValidator.validate("email"),
      false,
    );
  });
}
