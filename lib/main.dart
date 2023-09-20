import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/dashboard/dashboard.dart';
import 'features/auth/presentation/signup/sign_up.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/presentation/signin/sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Se inicia el servicio de Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context)),
        child: MaterialApp(
          initialRoute: '/signIn',
          //Se definen las rutas para un mejor acceso a ellas, uso namedroutes
          routes: {
            '/signIn': (context) => const SignIn(),
            '/signUp': (context) => const SignUp(),
            '/dashboard': (context) => const Dashboard(),
          },
          home: const SignIn(),
        ),
      ),
    );
  }
}
