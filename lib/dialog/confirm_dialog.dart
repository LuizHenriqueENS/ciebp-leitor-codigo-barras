import 'package:flutter/material.dart';

Future showConfirmDialog(
  BuildContext context,
  String title,
  String description,
) async {
  return showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  Icon(Icons.warning_sharp, color: Colors.red, size: 40),
                  Text(title),
                  Icon(Icons.warning_sharp, color: Colors.red, size: 40),
                ],
              ),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(0, 35, 0, 0),
                child: Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight(1000)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            child: Text(
              "Limpar histórico",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight(1000),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: ButtonStyle(
              elevation: WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            child: Text("Cancelar"),
          ),
        ],
      );
    },
  );
}
