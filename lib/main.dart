import 'package:checkout_app/constants.dart';
import 'package:checkout_app/firebase_options_copy.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/providers/product.dart';
import 'package:checkout_app/screens/product_detail_screen.dart';
import 'package:checkout_app/screens/splash_screen.dart';
import 'package:checkout_app/screens/update_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'providers/auth.dart';
import 'providers/notificationservice.dart';
import 'providers/push_notification_service.dart';
import 'screens/account_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tabs_screen.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(
    name: "Nutrihub",
    options: DefaultFirebaseOptions.currentPlatform,
  );

   // FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  // await PushNotificationService().setupInteractedMessage();

  // Stripe.merchantIdentifier = '';
  // Stripe.urlScheme = 'flutterstripe';

   // Stripe.publishableKey = stripeKey;
  // await Stripe.instance.applySettings();
  await Hive.initFlutter();
  
  runApp(const MyApp());
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FetchData(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Product(),
        )
      ],
      child:  MaterialApp(
            useInheritedMediaQuery: true,
            title: 'Nutrihub',
            theme: ThemeData(
              fontFamily: 'Poppins',
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                  .copyWith(secondary: kDarkButtonBg),
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            routes: {
              '/home': (ctx) => BottomNavBar(),
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              AccountScreen.routeName: (ctx) => AccountScreen(),
              BottomNavBar.id: (ctx) => BottomNavBar(),
              UpdateInfo.id: (ctx) => const UpdateInfo(),
            },
          )
        
    );
  }
}



