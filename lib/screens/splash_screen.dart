import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';

import 'tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic token;

  @override
  void initState() {
    donLogin();
    super.initState();
  }

  void donLogin() {
    Future.delayed(const Duration(seconds: 3), () async {
      token = await SharedPreferenceHelper().getAuthToken();
      if (token != null && token.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomNavBar()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomNavBar()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffa6d8be),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          child: Image.asset(
            'assets/images/splash.jpg',
            fit: BoxFit.cover,
          ),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),
      ),
    );
  }
}
