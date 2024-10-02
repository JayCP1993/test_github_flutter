import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController passwordController = TextEditingController();
  String imageSource = 'images/question-mark.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Login name'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (passwordController.text == 'QWERTY123') {
                  imageSource = 'images/light-bulb.jpg';
                } else {
                  imageSource = 'images/stop-sign.jpg';
                }
              });
            },
            child: Text('Login'),
          ),
          Image.asset(imageSource, width: 300, height: 300),
        ],
      ),
    );
  }
}
