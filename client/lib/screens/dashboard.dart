import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Image.asset(
          'assets/HealthVu_logo.png',
          fit: BoxFit.cover,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10.0,
            ),
            child: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      body: Center(
        child: Text('Signed in successfully!',
            style: GoogleFonts.montserrat(
              fontSize: 32,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () async {
          await storage.deleteAll();
          print('deleted token');
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }
}
