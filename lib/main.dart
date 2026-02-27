import 'package:eclipce_app/bottom/recovery_password.dart';
import 'package:eclipce_app/check.dart';
import 'package:eclipce_app/home.dart';
import 'package:flutter/material.dart';
import 'package:eclipce_app/loading.dart';
import 'package:eclipce_app/auth.dart';
import 'package:eclipce_app/reg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNteWF5cHJqaWR3anRwZWtscWZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE0ODg0OTYsImV4cCI6MjA4NzA2NDQ5Nn0.BPt0SWSWyX_AKQxfjHhX711mTn2-8PEucp2I5je0Ilw',
    url: 'https://smyayprjidwjtpeklqfg.supabase.co',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
