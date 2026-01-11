import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/grocery_provider.dart';
import 'screens/grocery_list_screen.dart';
import 'screens/login_screen.dart';
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroceryProvider()..fetchItems()),
        StreamProvider<User?>(create: (_) => AuthService().user, initialData: null),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        // توحيد اللون للأزرق الداكن
        primaryColor: const Color(0xFF0D47A1),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0D47A1)),
      ),
      home: user == null ? const LoginScreen() : const GroceryListScreen(),
    );
  }
}