import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  bool _isVisible = false;

  _StartupScreenState(){

    Timer(const Duration(milliseconds: 2000), (){
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
      });
    });

    Timer(
      const Duration(milliseconds: 10),(){
        setState(() {
          _isVisible = true; // Now it is showing fade effect and navigating to Login page
        });
      }
    );

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).secondaryHeaderColor, Theme.of(context).cardColor],
          begin: const FractionalOffset(1, 0),
          end: const FractionalOffset(1.0, 0.0),
          tileMode: TileMode.decal,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 170.0,
            width: 170.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(1.0),
                )
              ]
            ),
            child: const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'BeForReal', // ignore: spelling_error
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}