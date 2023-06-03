import 'package:flutter/material.dart';
import 'package:to_do_app/ui/login_screen/login_screen.dart';
import 'package:to_do_app/ui/register/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: Colors.blue,
      ),
      routes: {
        LoginScreen.routeName : (_)=>  LoginScreen(),
        RegisterScreen.routeName : (_)=> RegisterScreen(),
      },
      initialRoute: RegisterScreen.routeName,
    );
  }
}



