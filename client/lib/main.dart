import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:health_app/screens/dashboard.dart';
import 'package:health_app/screens/login.dart';
import 'package:health_app/screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = new FlutterSecureStorage();

  final token = await storage.read(key: 'JWT_TOKEN');

  print(token);

  runApp(MyApp( token: token,));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final String? token;

  const MyApp({Key? key, required this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: token == null ? LoginPage() : DashboardPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage()
      },
    );
  }
}
