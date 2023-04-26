import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeForReal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: blackMaterialColor,
      ),
      home: const MyHomePage(title: 'BeForReal'),
    );
  }
}

MaterialColor blackMaterialColor = MaterialColor(0xFF000000, {
  50: Colors.black,
  for (int i = 100; i <= 900; i += 100) i: Colors.black,
});

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.supervisor_account),
                iconSize: 30,
                color: Colors.white,
                tooltip: 'Friends',
                onPressed: () {
                  // do something when the button is pressed
                },
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    widget.title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: const Icon(Icons.account_circle),
                iconSize: 30,
                color: Colors.white,
                tooltip: 'Profile',
                onPressed: () {
                  // do something when the button is pressed
                },
              ),
            ),
          ],
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
