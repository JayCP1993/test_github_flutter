import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Load saved credentials when the app starts
  }

  // Load saved username and password
  _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        // Show a Snackbar when credentials are loaded
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Credentials loaded'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                usernameController.clear();
                passwordController.clear();
              });
            },
          ),
        ));
      }
    });
  }

  // Save username and password
  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', usernameController.text);
    prefs.setString('password', passwordController.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Credentials saved')));
  }

  // Clear saved username and password
  _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Credentials cleared')));
  }

  // Show AlertDialog to confirm saving credentials
  _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Credentials'),
          content: Text('Would you like to save your username and password?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearCredentials(); // Clear credentials if user chooses "No"
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveCredentials(); // Save credentials if user chooses "Yes"
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showSaveDialog, // Show save dialog when login button is clicked
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
