import 'package:flutter/material.dart';
import 'package:semanaleats/pages/home/home_page.dart';
import 'package:semanaleats/pages/products/create_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SemanalEats',
      initialRoute: 'home',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'create-product': (BuildContext context) => CreateProductPage(),
      },
    );
  }
}

