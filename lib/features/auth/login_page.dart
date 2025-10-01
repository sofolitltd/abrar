// asifreyad1@gmail.com

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/routes/app_route.dart';
import '../../providers/notifiers/user_notifier.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.route});

  final String? route;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login(String? route) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user == null) return;

        // notification
        await FirebaseMessaging.instance.subscribeToTopic('user');
        // await FirebaseMessaging.instance.subscribeToTopic('admin');
        var token = await FirebaseMessaging.instance.getToken();
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({"token": token});

        // in your login method, after Firebase signIn succeeds
        final container = ProviderScope.containerOf(context, listen: false);
        await container.read(userProvider.notifier).fetchUser();

        if (route == null) {
          context.go(AppRoute.home.path);
        } else if (route == '/profile') {
          context.go(AppRoute.profile.path);
        } else if (route == '/cart') {
          context.go(AppRoute.cart.path);
        } else {
          context.go(AppRoute.home.path);
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Failed: ${(e.code)}')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    print(route); // Cast to Map

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //
                    Text(
                      'Welcome to'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    //
                    const Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: 'Abrar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 32,
                        ),
                        children: [
                          TextSpan(
                            text: ' Shop',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Login Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Strong Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(route!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _login(route!),
                      child: _isLoading
                          ? const SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text('Login'.toUpperCase()),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Don\'t have an account yet?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        context.push(AppRoute.createAccount.path, extra: route);
                      },
                      child: const Text('Create New Account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
