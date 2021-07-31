import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter app teste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     debugShowCheckedModeBanner: false,
     restorationScopeId: 'app teste',
    );
  }
}