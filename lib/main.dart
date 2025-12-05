import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SupabaseService.onAuthStateChange.listen((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.currentUser();
    return MaterialApp(
      title: 'Supabase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: user == null ? const AuthScreen() : const HomeScreen(),
    );
  }
}
