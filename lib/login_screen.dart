import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final tbClient = ThingsboardClient(
    'https://demo.thingsboard.io',
  ); // <-- update if using local

  bool _isLoading = false;
  String _message = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      await tbClient.login(
        LoginRequest(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );

      // ✅ Only show success here
      setState(() {
        _message = "Login success! Token: ${tbClient.getJwtToken()}";
      });
    } catch (e) {
      setState(() {
        _message = "Login failed: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ThingsBoard Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.startsWith("Login success")
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
