
import 'package:be_for_real/chat/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


 import '../themHelper/reg_login_theme_helper.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final double _headerHeight = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                         child: Text(
                          'Welcome back !',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShadow(),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _username,
                                  validator: (value) => (value == null || !value.contains("@")) ? 'Email required' : null,
                                  decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    labelStyle: const TextStyle(color: Colors.white),
                                    hintText: 'Enter your E-mail',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.black87),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShadow(),
                                child: TextFormField(
                                  controller: _password,
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
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    labelText: 'Password',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                decoration: ThemeHelper().buttonRegisterDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    final email = _username.text.trim();
                                    final password = _password.text.trim();
                                    try {
                                      // Sign in the user with email and password
                                      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
                                      // Check if the user exists
                                      if (userCredential.user == null) {
                                        // User not found, show an error message
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not registered')));
                                        return;
                                      }
                                      // User found, navigate to the home page
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePageScreen()));
                                    } catch (e) {
                                      // Show an error message if sign-in failed
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign-in failed, please try again later')));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
                                    child: Text(
                                      "Login".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                          const TextSpan(text: "Don't have an account? "),
                                          TextSpan(
                                            text: 'Register',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()));
                                              },
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.cyan [400],
                                              fontSize: 18// set color to orange
                                            ),
                                          )
                                        ]
                                    )
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

