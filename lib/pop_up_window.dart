import 'package:ciebp_leitor/product.dart';
import 'package:flutter/material.dart';

class PopUpWindow extends StatefulWidget {
  const PopUpWindow({
    required this.barcode,
    required this.onAdd,
    super.key,
    required this.onClose,
  });

  final Function(Product) onAdd;
  final Function(bool) onClose;
  final String barcode;

  @override
  State<PopUpWindow> createState() => _PopUpWindowState();
}

class _PopUpWindowState extends State<PopUpWindow> {
  late TextEditingController nameTextFieldController = TextEditingController();
  late TextEditingController priceTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("NOVO PRODUTO"),
      content: SingleChildScrollView(
        child: Column(
          spacing: 14,
          children: [
            TextField(
              enabled: false,
              decoration: InputDecoration(
                label: Text(widget.barcode),
                border: OutlineInputBorder(),
              ),
            ),

            TextField(
              controller: nameTextFieldController,
              decoration: InputDecoration(
                label: Text("Nome do produto"),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: priceTextFieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Text("Preço do produto"),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            widget.onAdd(
              Product(
                barCode: widget.barcode,
                productName: nameTextFieldController.text,
                productPrice: double.parse(priceTextFieldController.text),
              ),
            );
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.add),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onClose(true);
          },
          icon: Icon(Icons.close),
        ),
      ],
    );
  }
}
