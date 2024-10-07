import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'profilepage.dart'; // Import the ProfilePage file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/profilePage': (context) => ProfilePage(), // Route to ProfilePage
      },
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
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage(); // Secure storage instance

  String imageSource = 'images/question-mark.jpg'; // Image for visual feedback

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Load saved credentials if they exist
  Future<void> _loadSavedCredentials() async {
    String? savedLogin = await storage.read(key: 'login');
    String? savedPassword = await storage.read(key: 'password');

    if (savedLogin != null && savedPassword != null) {
      loginController.text = savedLogin;
      passwordController.text = savedPassword;

      // Show Snackbar that credentials are loaded
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Previous login and password loaded'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Clear the text fields and delete credentials from secure storage
              setState(() {
                loginController.clear();
                passwordController.clear();
              });
              // Delete credentials from secure storage
              storage.delete(key: 'login');
              storage.delete(key: 'password');
            },
          ),
        ),
      );
    }
  }

  // Function to handle login button press
  void _onLoginPressed() {
    String login = loginController.text;
    String password = passwordController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials'),
          content: const Text('Would you like to save your login and password for next time?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                // Clear the saved credentials if the user selects "No"
                storage.delete(key: 'login');
                storage.delete(key: 'password');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Save login and password in secure storage
                storage.write(key: 'login', value: login);
                storage.write(key: 'password', value: password);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      // Navigate to ProfilePage, passing login or 'Guest' if empty
      Navigator.pushNamed(
        context,
        '/profilePage',
        arguments: login.isNotEmpty ? login : 'Guest',
      );
    });

    // Simple logic to change image based on password for demo purposes
    setState(() {
      if (password == "QWERTY123") {
        imageSource = 'images/light-bulb.jpg'; // Light bulb image if password is correct
      } else {
        imageSource = 'images/stop-sign.jpg'; // Stop sign if password is incorrect
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                labelText: 'Login name',
                hintText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Type Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Hides the password
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _onLoginPressed,
                child: const Text('Login'),
              ),
            ),
            // Image for visual feedback
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
