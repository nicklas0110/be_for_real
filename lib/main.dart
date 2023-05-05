import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat/screens/home_page.dart';
import 'chat/screens/login_screen.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Provider(create: (context) => ChatService()),
        StreamProvider(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        )
      ],
      builder: (context, child) {
        final user = Provider.of<User?>(context);
        return MaterialApp(
          title: 'Chat',
          darkTheme: ThemeData.from(
              colorScheme: ColorScheme.dark(background: Colors.black)),
          themeMode: ThemeMode.dark,
          home: user == null ? const LoginScreen() : const HomePageScreen(),
        );
      },
    );
  }
}