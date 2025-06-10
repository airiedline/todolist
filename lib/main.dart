import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/notification_service.dart';

const Color colorPrimary = Color(0xFFFFE1E6);
const Color colorAccent = Color(0xFFF7C9D4);
const Color colorBackground = Color(0xFFFFF1F4);
const Color colorText = Color(0xFFC8DE9D);
const Color colorBox = Color(0xFFFFFFFF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
  primaryColor: colorPrimary,
  scaffoldBackgroundColor: colorBackground,
  colorScheme: ColorScheme.light(
    primary: colorPrimary,
    secondary: colorAccent,
    background: colorBackground,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimary,
    foregroundColor: Colors.black87,
  ),
  cardColor: colorBox,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: colorText),
    bodyMedium: const TextStyle(color: Colors.black87),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorAccent,
      foregroundColor: Colors.black87,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: colorBox,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
  iconTheme: IconThemeData(color: colorText),
);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todolist',
      theme: lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
