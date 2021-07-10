import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:health_app/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // global form key
  final _formKey = GlobalKey<FormState>();

  // form state variables
  User _user = User('', '', '');

  // create secure storage
  final storage = new FlutterSecureStorage();

  // form onsubmit handler
  _onSubmit() async {
    try {
      var res = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
          <String, String>{
            'email': _user.email,
            'password': _user.password,
          },
        ),
      );

      var resObj = jsonDecode(res.body);

      if (res.statusCode == 200 && resObj["code"] == 'signin-success') {
        print(resObj["token"]);
        await storage.write(key: 'JWT_TOKEN', value: resObj["token"]);
        print('Saved token');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              resObj['message'],
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              resObj['message'],
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            error.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  // signin method

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(11, 8, 0, 0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'To purchase HealthVu Basic',
              style: GoogleFonts.montserrat(
                color: Color(0xff332F2F),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'please log in',
              style: GoogleFonts.montserrat(
                color: Color(0xff332F2F),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset(
              'assets/Login_Image.png',
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 32,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      onSaved: (value) {
                        _user.email = value.toString();
                      },
                      decoration: InputDecoration(
                        hintText: 'Username*',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        final isValidEmail =
                            !EmailValidator.validate(value, true);
                        return isValidEmail ? 'Enter a valid email.' : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      onSaved: (value) {
                        _user.password = value.toString();
                      },
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      // controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password*',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'New User? Sign Up',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          letterSpacing: 1.7,
                          color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          elevation: 10,
                          primary: Color(0xff000a42)),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          _onSubmit();
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Forgot Details?',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                letterSpacing: 1.5,
                color: Color(0xff7c7c7c),
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
