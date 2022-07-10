import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => AuthenticateState();
}

class AuthenticateState extends State<Authenticate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool obscurePassword = true;

  bool createAccount = true;
  FirebaseAuthException? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Chat App',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    autocorrect: false,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter an email';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: obscurePassword,
                        autocorrect: false,
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a password';
                          }

                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: obscurePassword ? Colors.black : Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        child: Text(
                          createAccount ? 'Create Account' : 'Login',
                        ),
                        onPressed: () async {
                          if (!mounted) return;

                          setState(() {
                            _error = null;
                          });

                          if (_formKey.currentState!.validate()) {
                            try {
                              if (createAccount) {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                              } else {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              if (!mounted) return;

                              setState(() {
                                _error = e;
                              });

                              if (kDebugMode) rethrow;
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      if (_error != null)
                        Text(
                          _error!.message ?? 'Something went wrong',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      const SizedBox(height: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          createAccount
                              ? 'Already have an account?'
                              : 'Create Account',
                        ),
                        onPressed: () {
                          setState(() {
                            createAccount = !createAccount;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
