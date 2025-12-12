import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // VALIDASI DASAR
  bool _validateInput(String email, String pass) {
    if (!email.contains("@") || !email.contains(".")) {
      _showMessage("Email tidak valid. Contoh: nama@gmail.com");
      return false;
    }
    if (pass.length < 8) {
      _showMessage("Password minimal 8 karakter!");
      return false;
    }
    return true;
  }

  // PESAN SNACKBAR
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (!_validateInput(email, pass)) return;

    setState(() => _loading = true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } catch (e) {
      _showMessage("Login gagal: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (!_validateInput(email, pass)) return;

    setState(() => _loading = true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    } catch (e) {
      _showMessage("Registrasi gagal: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login/Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: _register, child: const Text("Register")),
                  ElevatedButton(
                      onPressed: _login, child: const Text("Login")),
                ],
              )
          ],
        ),
      ),
    );
  }
}