import 'package:be_for_real/chat/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/frontLogo.png",
                  width: 170,
                  height: 170,
                ),
                Text(
                  'Welcome back 😀 !',
                ),
                const SizedBox(height: 10),
                usernameInput(),
                passwordInput(),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final email = _username.text.trim();
                    final password = _password.text.trim();
                    try {
                      // Sign in the user with email and password
                      final userCredential = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      // Check if the user exists
                      if (userCredential.user == null) {
                        // User not found, show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('User not registered')),
                        );
                        return;
                      }
                      // User found, navigate to the home page
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePageScreen(),
                        ),
                      );
                    } catch (e) {
                      // Show an error message if sign-in failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Sign-in failed, please try again later')),
                      );
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(200, 40)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[400]!),
                  ),
                ),

                const SizedBox(height: 16),

                newBtn(context),

              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton newBtn(BuildContext context) {
    return ElevatedButton(
      child: const Text('Register'),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          setState(() {});
          return;
        }
        final email = _username.value.text.trim();
        final password = _password.value.text.trim();
        try {
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          print(userCredential.user!.uid);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create user'),
            ),
          );
        }
      },
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(200, 40)),
        backgroundColor:
        MaterialStateProperty.all<Color>(Colors.grey[400]!),
      ),
    );
  }




  Padding usernameInput() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _username,
        decoration: InputDecoration(
          hintText: 'Enter your email',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        validator: (value) =>
        (value == null || !value.contains("@")) ? 'Email required' : null,
      ),
    );
  }

  Padding passwordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adding horizontal padding
      child: TextFormField(
        controller: _password,
        decoration:  InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.length < 6) {
            return 'Password required (min 6 chars)';
          } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return 'Password must contain at least one uppercase letter';
          } else if (!RegExp(r'\d').hasMatch(value)) {
            return 'Password must contain at least one number';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
