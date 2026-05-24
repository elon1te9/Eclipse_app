import 'package:eclipse_app/bottom/recovery_password.dart';
import 'package:eclipse_app/check.dart';
import 'package:eclipse_app/config/supabase_config.dart';
import 'package:eclipse_app/home.dart';
import 'package:flutter/material.dart';
import 'package:eclipse_app/loading.dart';
import 'package:eclipse_app/auth.dart';
import 'package:eclipse_app/reg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(anonKey: supabaseAnonKey, url: supabaseUrl);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eclipse App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(),
        '/auth': (context) => AuthPage(),
        '/reg': (context) => RegPage(),
        '/home': (context) => HomePage(),
        '/check': (context) => CheckPage(),
        '/recpass': (context) => RecoveryPasswordPage(),
      },
    );
  }
}
