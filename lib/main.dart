import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/bloc/block_bloc.dart';
import 'package:notes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/screens/splash_screen.dart';
import 'package:notes/widgets/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instanceFor(app: app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: state,
            darkTheme: AppTheme().darkTheme,
            theme: AppTheme().lightTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
