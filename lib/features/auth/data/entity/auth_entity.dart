class AuthEntity {
  late String userName;
  late String password;

  AuthEntity(this.userName, this.password);

  bool isValidForm() => userName.isNotEmpty && password.isNotEmpty;
}
