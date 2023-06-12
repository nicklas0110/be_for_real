import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'Alexs_Firebase_mappe/firebase_chat_service.dart';
import 'home_screen.dart';
import 'LoginRegisterStartup/startup_screen.dart';
import 'Alexs_Firebase_mappe/firebase_options.dart';
import 'package:be_for_real/Alexs_Firebase_mappe/firebase_daily_picture.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission();

  final token = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('FCM token: $token');
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const channel = AndroidNotificationChannel(
    'daily_notifications',
    'Daily_Notifications',
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
      android: AndroidInitializationSettings('app_icon'),
    ),
  );

  assert(
  initialized ?? false,
  'There was a problem initializing the FlutterLocalNotificationsPlugin',
  );

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
        ),
      );
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChatService>(create: (context) => ChatService()),
        Provider<FirebaseDailyPicture>(
          create: (context) => FirebaseDailyPicture(),
        ),
        Provider<HomeScreen>(create: (context) => const HomeScreen()),
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      builder: (context, child) {
        final user = Provider.of<User?>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.from(
            colorScheme: const ColorScheme.dark(background: Colors.black),
          ),
          themeMode: ThemeMode.dark,
          home: user == null
              ? const StartupScreen(title: 'Flutter Login UI')
              : const HomeScreen(),
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
}

