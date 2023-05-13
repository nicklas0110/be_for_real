import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'chat/screens/home_page.dart';
import 'chat/screens/loginReg/pages/startup_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (await Permission.camera.request().isGranted) {}

  runApp(const MyApp());

  await FirebaseMessaging.instance.requestPermission();

  final token = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('FCM token: $token');
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const channel = AndroidNotificationChannel(
    'channel_message',
    'Channel_Message',
    description:
        'Whenever a message is sent to one of the member channels, this feature triggers the display of a notification on the user s device.',
    importance: Importance.max,
  );

  final notifications = FlutterLocalNotificationsPlugin();
  await notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  final initialized = await notifications.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('app_icon')));

  assert(initialized ?? false,
      'there was a problem initializing the FlutterLocalNotificationsPlugin');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      notifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android.smallIcon,
            ),
          ));
    }
  });
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
  }

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
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.from(
              colorScheme: const ColorScheme.dark(background: Colors.black)),
          themeMode: ThemeMode.dark,
          home: user == null
              ? const StartupScreen(title: 'Flutter Login UI')
              : const HomePageScreen(),
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
