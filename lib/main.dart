import 'package:flutter/material.dart';
import 'package:its_food/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
          // ignore: prefer_const_constructors
          title: 'ITS Foods',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ), // ThemeData
          home: HomeScreen(),
        );
      }),
    );
  }
}

