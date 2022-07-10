import 'package:chat_app/routes/authenticate/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);

    if (user == null) {
      return const Authenticate();
    }

    return Scaffold(
      body: Center(
        child: Text('Welcome ${user.email}'),
      ),
    );
  }
}
