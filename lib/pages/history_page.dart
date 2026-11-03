import 'package:ciebp_leitor/data/sell_history.dart';
import 'package:ciebp_leitor/model/history.dart';
import 'package:ciebp_leitor/util/app_colors.dart';
import 'package:ciebp_leitor/util/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ciebp_leitor/dialog/confirm_dialog.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 45),
            child: Text(
              "Aqui é exibido todo o histórico de vendas por [ ordem decrescente ]",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight(900), fontSize: 24),
            ),
          ),
          Expanded(flex: 1, child: historyTable()),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
            child: ElevatedButton(
              onPressed: () async {
                bool resp = await showConfirmDialog(
                  context,
                  "Atenção!",
                  "Você está prestes a excluir todo o histórico de venda. Essa ação é irreversível. Tem certeza que deseja continuar?",
                );

                if (resp) {
                  SellHistory sell = SellHistory();
                  sell.clearHistory();

                  setState(() {
                    getList();
                  });
                }
              },
              child: Text("Limpar"),
            ),
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
              border: TableBorder.all(width: 1, borderRadius: BorderRadius.all(Radius.circular(5))),
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
                        dataCellText: DateFormat("dd/MM/yyyy - HH:mm").format(history.sellDate.toLocal()),
                      ),
                      tableCell(history: history, dataCellText: MoneyFormatter.brl(history.sellValue)),
                    ],
                  ),
              ],
            ),
          );
  }

  DataCell tableCell({required History history, required String dataCellText}) {
    return DataCell(
      Center(
        child: Text(dataCellText, style: TextStyle(fontWeight: FontWeight(300))),
      ),
    );
  }

  DataColumn tableHead({required String headText}) {
    return DataColumn(
      columnWidth: FixedColumnWidth(150),
      headingRowAlignment: MainAxisAlignment.center,
      label: Text(headText, style: TextStyle(fontWeight: FontWeight(900))),
    );
  }
}
