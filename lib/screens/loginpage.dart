import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanrakshan/controller/auth.dart';
import 'package:sanrakshan/screens/mainPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: pass,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? u = await FireAuth.signInUsingEmailPassword(
                    email: email.text, password: pass.text, context: context);
                    if(u!= null)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(user: u)));
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
