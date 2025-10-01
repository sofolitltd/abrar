import 'package:abrar/routes/app_route.dart';
import 'package:abrar/routes/router_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../../providers/notifiers/user_notifier.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key, this.route});
  final String? route;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final route = widget.route;

    //
    void createAccount(route) async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        try {
          UserCredential userCredential = await _auth
              .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );

          if (userCredential.user == null) return;

          // notification
          await FirebaseMessaging.instance.subscribeToTopic('user');
          var token = await FirebaseMessaging.instance.getToken();

          //
          final user = UserModel(
            uid: userCredential.user!.uid,
            name: _nameController.text.trim(),
            mobile: _mobileNumberController.text.trim(),
            email: _emailController.text.trim(),
            image: '',
            createdDate: Timestamp.now(),
            token: token ?? "",
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(user.toJson());

          //
          final container = ProviderScope.containerOf(context, listen: false);
          await container.read(userProvider.notifier).fetchUser();

          //
          if (route == null) {
            routerConfig.go(AppRoute.home.path);
          } else if (route == '/profile') {
            routerConfig.go(AppRoute.profile.path);
          } else if (route == '/checkout') {
            routerConfig.go(AppRoute.checkout.path);
          } else {
            routerConfig.go(route); // fallback for other cases
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Signup Failed: $e')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
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
                    //
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter Certificate Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                          _mobileNumberFocusNode,
                        ); // Move focus to next
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileNumberController,
                      focusNode: _mobileNumberFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        hintText: 'Enter Mobile No',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (_) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_emailFocusNode); // Move focus to next
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Only numbers
                        LengthLimitingTextInputFormatter(11), // Max 11 digits
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (value.length != 11) {
                          return 'Mobile number must be 11 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Active Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                          _passwordFocusNode,
                        ); // Move focus to next
                      },
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Strong Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: !_isPasswordVisible,
                      onFieldSubmitted: (_) {
                        createAccount(route); // Submit form
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        text: 'Please remember your ',
                        style: Theme.of(context).textTheme.titleSmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Email',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(),
                          ),
                          TextSpan(
                            text: 'Password',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                          ),
                          TextSpan(
                            text: ' for further login. ',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => createAccount(route),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(),
                            )
                          : Text('Create Account'.toUpperCase()),
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
