import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout,
              size: 22,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Book Train tickets',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
