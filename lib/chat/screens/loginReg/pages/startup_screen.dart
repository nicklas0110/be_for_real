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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        });
      }
    });

    Timer(const Duration(milliseconds: 10), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
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
            ],
          ),
          child: const Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'BeForReal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
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
