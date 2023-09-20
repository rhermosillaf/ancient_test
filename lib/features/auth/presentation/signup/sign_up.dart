import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:email_validator/email_validator.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../presentation/dashboard/dashboard.dart';
import '../../presentation/signin/sign_in.dart';
import '../../../../core/widgets/custom_text_input.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registra tu nueva cuenta"),
      ),

      //Se agrega BlocListener con el objetivo de ejecutar métodos que corresponda a cada estado
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Si el estado es Authenticated se muestra la pantalla Dashboard para mostrar la información del usuario
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
            );
          }
          //Si el estado es de error, se muestra us snackbar con mensaje de error
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            //Mientras se ejecuta la acción de registrar, se muestra al centro un indicador de progreso circular
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnAuthenticated) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Ingresa tus datos",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Center(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              emailBoxContainer(context),
                              const SizedBox(
                                height: 10,
                              ),
                              passwordBoxContainer(context),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _createAccountWithEmailAndPassword(context);
                                  },
                                  child: const Text('Regístrar'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Text("¿Ya tienes una cuenta?"),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ),
                          );
                        },
                        child: const Text("Ingresar"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  //Se llama a este procedimiento para ejecutar la acción de crear (signUp) usuario de firebase
  //Nótese que no se usan argumentos, dado que el bloc es el encargado de manipular los datos de email y password
  //En este caso sólo se usa como argumento el contexto
  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(),
      );
    }
  }

  Widget emailBoxContainer(BuildContext context) {
    return CustomTextInput(
      controller: _emailController,
      hintText: "Email",
      obscureText: false,
      validator: (value) {
        return !EmailValidator.validate(value!)
            ? 'No es un email válido'
            : null;
      },
      onChanged: (value) {
        BlocProvider.of<AuthBloc>(context).add(
          EmailTextChanged(value),
        );
      },
    );
  }

  //se utiliza botón customizado
  Widget passwordBoxContainer(BuildContext context) {
    return CustomTextInput(
      controller: _passwordController,
      hintText: "Password",
      obscureText: true,
      validator: (value) {
        return value!.isEmpty ? "Ingrese contraseña válida" : null;
      },
      onChanged: (value) {
        BlocProvider.of<AuthBloc>(context).add(
          PasswordTextChanged(value),
        );
      },
    );
  }
}
