import 'package:car_renting/core/theme/app_theme.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_field.dart';
import 'package:car_renting/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.appTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: .all(16),
          child: Column(
            spacing: 16,
            mainAxisAlignment: .center,
            children: [
              CustomField(
                hintText: 'hintText',
                controller: TextEditingController(),
              ),
              CustomButton(
                text: 'Create Account',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheet(
                      onClosing: () => Navigator.of(context).pop(),
                      builder: (context) =>
                          Column(children: [Text('BOTTOMSHEET')]),
                    ),
                  );
                },
              ),
              Card(
                child: Padding(
                  padding: .all(16),
                  child: Column(children: [Text('TESTING')]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Account'),
        ],
      ),
    );
  }
}
