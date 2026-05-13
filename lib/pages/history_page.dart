import 'package:ciebp_leitor/data/sell_history.dart';
import 'package:ciebp_leitor/model/history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<History> list = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    SellHistory sellHistory = SellHistory();
    list = await sellHistory.getAll();

    setState(() {
      list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          historyTable(),
          ElevatedButton(
            onPressed: () {
              SellHistory sell = SellHistory();
              sell.clearHistory();

              setState(() {
                getList();
              });
            },
            child: Text("Limpar"),
          ),
        ],
      ),
    );
  }

  StatelessWidget historyTable() {
    double columnMarginSpace = 25;

    return list.isEmpty
        ? Text("Não há histórico")
        : SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              horizontalMargin: columnMarginSpace / 2,
              columnSpacing: columnMarginSpace,
              border: TableBorder.all(
                width: 1,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              columns: [
                tableHead(headText: "Data"),
                tableHead(headText: "Valor"),
              ],
              rows: [
                for (var history in list)
                  DataRow(
                    cells: [
                      tableCell(
                        history: history,
                        dataCellText: DateFormat(
                          "dd/MM/yyyy - HH:mm",
                        ).format(history.sellDate.toLocal()),
                      ),
                      tableCell(
                        history: history,
                        dataCellText: "${history.sellValue}",
                      ),
                    ],
                  ),
              ],
            ),
          );
  }

  DataCell tableCell({required History history, required String dataCellText}) {
    return DataCell(
      Center(
        child: Text(
          dataCellText,
          style: TextStyle(
            fontWeight: FontWeight(300),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  DataColumn tableHead({required String headText}) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Text(headText, style: TextStyle(fontWeight: FontWeight(900))),
    );
  }
}
