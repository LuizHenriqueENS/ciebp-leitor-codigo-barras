import 'package:ciebp_leitor/file_handler.dart';
import 'package:ciebp_leitor/pop_up_window.dart';
import 'package:ciebp_leitor/product.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  MobileScannerController controller = MobileScannerController(
    detectionTimeoutMs: 1250,
  );

  FileHandler fh = FileHandler();
  List<Product> productsDatabase = [];

  bool showCamera = false;
  bool canRead = true;
  @override
  void initState() {
    super.initState();

    showProducts();
  }

  void showProducts() async {
    productsDatabase = await fh.findAll();

    setState(() {
      productsDatabase;
    });
  }

  void showPopUp(BuildContext context, String data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopUpWindow(
          barcode: data,
          onAdd: (e) async {
            bool saved = await fh.saveProduct(e);

            if (saved) {
              List<Product> data = await fh.findAll();
              setState(() {
                productsDatabase = data;
                canRead = true;
              });
            }
          },
          onClose: (resp) {
            setState(() {
              canRead = resp;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.5,
      children: [
        SizedBox(
          width: 400,
          height: 200,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showCamera = !showCamera;
              });
            },
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              elevation: WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            child: showCamera
                ? MobileScanner(
                    controller: controller,
                    onDetect: (result) {
                      if (!canRead) {
                        return;
                      }
                      String? data = result.barcodes.first.rawValue;
                      bool productInList = false;
                      for (var e in productsDatabase) {
                        if (e.barCode == data) {
                          productInList = true;
                        }
                      }
                      if (data != null && !productInList) {
                        canRead = false;
                        showPopUp(context, data);
                      }
                    },
                  )
                : SizedBox.expand(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_sharp,
                            color: Colors.white,
                            size: 36,
                          ),
                          Text(
                            "Clique para ativar a camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        Text(
          "Escaneie um código de barra para adicioná-lo ao banco de dados.",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight(900)),
          textAlign: TextAlign.center,
        ),
        FittedBox(
          child: DataTable(
            clipBehavior: Clip.hardEdge,
            headingTextStyle: TextStyle(fontWeight: FontWeight(900)),
            dataTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight(300),
            ),
            border: TableBorder.all(width: 1),
            showCheckboxColumn: false,
            columns: [
              DataColumn(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text("Código de barra"),
              ),
              DataColumn(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text("Produto"),
              ),
              DataColumn(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text("Preço"),
              ),
              DataColumn(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text("#"),
              ),
            ],
            rows: [
              for (Product p in productsDatabase)
                DataRow(
                  onSelectChanged: (e) {
                    print(p);
                  },
                  cells: [
                    DataCell(Center(child: Text(p.barCode))),
                    DataCell(Center(child: Text(p.productName))),
                    DataCell(Center(child: Text(p.productPrice.toString()))),
                    DataCell(
                      Center(
                        child: IconButton(
                          onPressed: () async {
                            bool resp = await showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text(
                                    "Remover ${p.productName}?",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop((true));
                                          },
                                          child: Text("Remover"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop((false));
                                          },
                                          child: Text("Cancelar"),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                            print(resp);

                            if (!resp) {
                              return;
                            }
                            await fh.deleteProduct(p);

                            setState(() {
                              showProducts();
                            });
                          },
                          icon: Icon(Icons.remove_circle_outlined),
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
