import 'package:ciebp_leitor/pages/checkout_page.dart';
import 'package:ciebp_leitor/pages/database_page.dart';
import 'package:ciebp_leitor/pages/history_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentSelection = 2;

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Carrinho"),

    BottomNavigationBarItem(
      icon: Icon(Icons.history_sharp),
      label: "Histórico",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt_sharp),
      label: "Produtos",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentSelection,
          items: items,
          onTap: (index) {
            setState(() {
              currentSelection = index;
            });
          },
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: switch (currentSelection) {
              0 => CheckoutPage(),
              1 => HistoryPage(),
              2 => DatabasePage(),
              int() => throw UnimplementedError(),
            },
          ),
        ),
      ),
    );
  }
}
