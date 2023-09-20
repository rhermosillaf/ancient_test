import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../presentation/signin/sign_in.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Se obtiene el usuario desde la instancia de Firebase
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus datos!'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            //Nos movemos a la pantalla de login o ingreso si el estado es UnAuthenticated
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignIn()),
              (route) => false,
            );
          }
        },
        //aplicamos animación vertical en que se despliegan desde la derecha los widgets en forma vertical, con un delay de tiempo
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 1500),
                childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                children: [
                  Text(
                    'Email: \n ${user.email}',
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  user.displayName != null
                      ? Text("${user.displayName}")
                      : Container(),
                  user.uid.isNotEmpty ? Text(user.uid) : Container(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Salir'),
                    onPressed: () {
                      //Salimos de la sesión
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
