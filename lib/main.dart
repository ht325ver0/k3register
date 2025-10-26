import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'view/home_page.dart';

Future<void> main() async {
  // .envファイルをロード
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized(); // Flutterの初期化を確認
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ??
        (throw ArgumentError(
            'SUPABASE_URL is not set in .env file. Please create .env file and add SUPABASE_URL.')),
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ??
        (throw ArgumentError(
            'SUPABASE_ANON_KEY is not set in .env file. Please create .env file and add SUPABASE_ANON_KEY.')),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'k3register',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
