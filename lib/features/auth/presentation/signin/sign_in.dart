import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_text_input.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../presentation/dashboard/dashboard.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final enableButton = false;

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
        title: const Text("Ancient test"),
      ),
      //Se agrega BlocListener con el objetivo de mantener en escucha los cambios
      //de estado y ejecutar las acciones que corresponda a algunos de ellos
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Nos cambiamos a la pantalla <DashBoard> en caso de autenticación
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Dashboard()));
          }
          if (state is AuthError) {
            // Se muestra snackbar con mensade de error en caso que falle el
            // proceso de autenticación
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        // Se agrega un BlocBuilder para dibujar los widgets necesarios para
        // cada cambio de estado
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              // Para un estado de carga se muestra un progressIndicator al centro
              // de la pantalla
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Mientras el estado sea NoAutenticado entonces se dibujan todos los
            // widgets necesarios para que el usuario ingrese sus datos
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
                          "Ingresa aquí!",
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
                                const SizedBox(height: 10),
                                passwordBoxContainer(context),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(
                                          context);
                                    },
                                    child: const Text('Ingresar'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Text("¿No tienes una cuenta?"),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/signUp', (route) => false);
                          },
                          child: const Text("Regístrate!"),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            //En último caso, se dibuja un Container vacío para cerrar la lógica del if
            return Container();
          },
        ),
      ),
    );
  }

  //se utiliza botón customizado
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

  //Se llama a este procedimiento para ejecutar la acción de ingresar (signIn) usuario de firebase
  //Nótese que no se usan argumentos, dado que el bloc es el encargado de manipular los datos de email y password
  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(),
      );
    }
  }
}
