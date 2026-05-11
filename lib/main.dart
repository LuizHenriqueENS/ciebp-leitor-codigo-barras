import 'package:ciebp_leitor/checkout.dart';
import 'package:ciebp_leitor/file_handler.dart';
import 'package:ciebp_leitor/pages/add_product.dart';
import 'package:ciebp_leitor/products.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
              0 => ScannerPage(),
              1 => Column(children: [
                ],
              ),
              2 => AddProduct(),
              int() => throw UnimplementedError(),
            },
          ),
        ),
      ),
    );
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController? controllerScanner = MobileScannerController(
    detectionTimeoutMs: 500,
  );
  String barCode = "";

  ScrollController scrollViewController = ScrollController();

  List<Product> rawList = [];
  Map<Product, int> itemsOrders = {};

  void addItem(Product prod) {
    if (itemsOrders.containsKey(prod)) {
      itemsOrders[prod] = (itemsOrders[prod] ?? 0) + 1;
    } else {
      itemsOrders[prod] = 1;
    }

    print(itemsOrders);
  }

  double calculateTotal() {
    double sum = 0;
    for (Product p in itemsOrders.keys) {
      sum += p.productPrice * itemsOrders[p]!;
    }

    return sum;
  }

  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollViewController.animateTo(
        scrollViewController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Container(
            height: 150,
            width: 450,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
            ),
            child: MobileScanner(
              controller: controllerScanner,
              onDetect: (result) async {
                String data = result.barcodes.first.rawValue.toString();
                Product? product;
                if (data.isNotEmpty) {
                  FileHandler database = FileHandler();
                  product = await database.findByBarcode(data);
                }

                if (product != null) {
                  setState(() {
                    addItem(product!);
                  });
                  scrollToEnd();
                }
              },
            ),
          ),
        ),

        FittedBox(
          child: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              controller: scrollViewController,
              child: DataTable(
                columns: [
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Quantidade"),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Produto"),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Preço Un."),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Sub-Total"),
                  ),
                ],
                rows: [
                  for (Product p in itemsOrders.keys)
                    DataRow(
                      cells: [
                        DataCell(
                          Center(child: Text(itemsOrders[p].toString())),
                        ),
                        DataCell(Center(child: Text(p.productName))),
                        DataCell(
                          Center(child: Text(p.productPrice.toString())),
                        ),
                        DataCell(
                          Center(
                            child: Text("${p.productPrice * itemsOrders[p]!}"),
                          ),
                        ),
                      ],
                    ),
                  DataRow(
                    cells: [
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(
                        Center(
                          child: Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight(900)),
                          ),
                        ),
                      ),
                      DataCell(Center(child: Text("${calculateTotal()}"))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
