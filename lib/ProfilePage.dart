import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final storage = const FlutterSecureStorage(); // Secure storage instance

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data on init
  }

  // Function to load profile data
  Future<void> _loadProfileData() async {
    firstNameController.text = await storage.read(key: 'firstName') ?? '';
    lastNameController.text = await storage.read(key: 'lastName') ?? '';
    phoneController.text = await storage.read(key: 'phone') ?? '';
    emailController.text = await storage.read(key: 'email') ?? '';
  }

  // Function to save profile data
  void _saveProfileData() async {
    await storage.write(key: 'firstName', value: firstNameController.text);
    await storage.write(key: 'lastName', value: lastNameController.text);
    await storage.write(key: 'phone', value: phoneController.text);
    await storage.write(key: 'email', value: emailController.text);
  }

  // Function to launch the dialer
  Future<void> _launchDialer(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showAlert('Phone not supported on this device.');
    }
  }

  // Function to launch SMS
  Future<void> _launchSMS(String phoneNumber) async {
    final Uri url = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showAlert('SMS not supported on this device.');
    }
  }

  // Function to launch email client
  Future<void> _launchEmail(String emailAddress) async {
    final Uri url = Uri(scheme: 'mailto', path: emailAddress);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showAlert('Email not supported on this device.');
    }
  }

  // Function to show unsupported URL alert
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String loginName = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'Guest'; // Handle null login name

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        leading: BackButton(
          onPressed: () {
            _saveProfileData(); // Save profile data when navigating back
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome Back, $loginName"),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () => _launchDialer(phoneController.text),
                ),
                IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: () => _launchSMS(phoneController.text),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mail),
                  onPressed: () => _launchEmail(emailController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
