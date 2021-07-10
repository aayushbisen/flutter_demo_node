import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:health_app/user.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
// global form key
  final _formKey = GlobalKey<FormState>();

  // form state variables
  User _user = User('', '', '');

  // form onsubmit handler
  Future<void> _onSubmit() async {

    try {
    var res = await http.post(Uri.parse("http://10.0.2.2:8000/api/register"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'name': _user.name,
          'email': _user.email,
          'password': _user.password
        }));

    var resObj = jsonDecode(res.body);

    if (resObj["code"] == 'user-created') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            resObj['message'],
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      await Future.delayed(const Duration(seconds: 5));
      Navigator.pushReplacementNamed(context, '/login');
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
    } catch( error){
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
            SizedBox(
              height: 20,
            ),
            Text(
              'Sign Up',
              style: GoogleFonts.montserrat(
                color: Color(0xff332F2F),
                fontSize: 25,
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
                        _user.name = value.toString();
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
                        return null;
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
                        _user.email = value.toString();
                      },
                      decoration: InputDecoration(
                        hintText: 'Email*',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
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
                        _onSubmit();
                      },
                      child: Text(
                        'Sign Up',
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
          ],
        ),
      ),
    );
  }
}
