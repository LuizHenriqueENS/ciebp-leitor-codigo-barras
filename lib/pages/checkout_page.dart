import 'package:ciebp_leitor/data/sell_history.dart';
import 'package:ciebp_leitor/file_handler.dart';
import 'package:ciebp_leitor/model/history.dart';
import 'package:ciebp_leitor/product.dart';
import 'package:ciebp_leitor/util/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  MobileScannerController? controllerScanner = MobileScannerController(
    detectionTimeoutMs: 3000,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 24,
            children: [
              SizedBox(
                height: 150,
                width: 450,
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

              itemsOrders.isNotEmpty
                  ? SingleChildScrollView(
                      controller: scrollViewController,
                      child: DataTable(
                        showCheckboxColumn: false,
                        horizontalMargin: 5,
                        columnSpacing: 5,
                        border: TableBorder.all(width: 0.7),
                        columns: [
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Center(child: Text("Qtd")),
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
                              onSelectChanged: ((e) {
                                itemsOrders[p] = (itemsOrders[p] ?? 0) - 1;
                                if (itemsOrders[p]! <= 0) {
                                  itemsOrders.removeWhere(
                                    (key, value) => key == p,
                                  );
                                }
                                setState(() {
                                  itemsOrders;
                                });
                              }),
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(itemsOrders[p].toString()),
                                  ),
                                ),
                                DataCell(Center(child: Text(p.productName))),
                                DataCell(
                                  Center(
                                    child: Text(
                                      MoneyFormatter.brl(p.productPrice),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      MoneyFormatter.brl(
                                        p.productPrice * itemsOrders[p]!,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    )
                  : Text("Escaneie para adicionar ao carrinho"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    MoneyFormatter.brl(calculateTotal()),
                    style: TextStyle(
                      fontWeight: FontWeight(900),
                      color: Colors.green,
                      fontSize: 34,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (calculateTotal() <= 0) {
                        return;
                      }
                      SellHistory history = SellHistory();
                      await history.saveHistory(
                        History(
                          sellDate: DateTime.now(),
                          sellValue: calculateTotal(),
                        ),
                      );

                      setState(() {
                        itemsOrders.clear();
                      });
                    },
                    child: Text("VENDER"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
