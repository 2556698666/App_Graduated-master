
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final url = Uri.parse('http://school_mangment.test/api/login?email=$email&password=$password');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        } else {
          _showError('Invalid credentials');
        }
      } else {
        _showError('Login failed. Please try again.');
      }
    } catch (e) {
      _showError('Connection error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 160,
                      child: Image.asset('assets/login.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!value.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your password';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) _login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Don't have an Account?", style: TextStyle(fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1976D2),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        child: const Text('Create Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
