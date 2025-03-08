import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Home.dart'; 
import 'Register/Register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login', //i didnot craeted any home page so login as the initial route
        routes: {
          '/login': (context) => const LoginPage(), // Login page route
          '/register': (context) => const RegisterPage(), // register page route
        },
      );
}