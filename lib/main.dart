import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'chat/chat_service.dart';
import 'chat/screens/home_page.dart';
import 'chat/screens/login_screen.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (await Permission.camera.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChatService>(create: (context) => ChatService()),
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        )
      ],
      builder: (context, child) {
        final user = Provider.of<User?>(context);
        return MaterialApp(
          title: 'Chat',
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.from(
              colorScheme: ColorScheme.dark(background: Colors.black)),
          themeMode: ThemeMode.dark,
          home: user == null ? const LoginScreen() : const HomePageScreen(),
        );
      },
    );
  }
}