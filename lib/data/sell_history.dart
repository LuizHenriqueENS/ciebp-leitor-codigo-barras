import 'dart:convert';
import 'dart:io';
import 'package:ciebp_leitor/model/history.dart';
import 'package:path_provider/path_provider.dart';

class SellHistory {
  Future<String> get _database async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/history.json";

    final fileExisit = File(path).exists();
    if (!await fileExisit) {
      try {
        await File(path).create();
        await File(path).writeAsString("[]");
      } catch (e) {
        print("Falha ao criar arquivo $e");
      }
    }
    return path;
  }

  Future<bool> saveHistory(History history) async {
    try {
      String jsonData = await File(await _database).readAsString();

      String newJson = "[";
      List<History> histories = jsonToObject(jsonData);
      histories.add(history);
      histories.sort((a, b) => b.sellDate.compareTo(a.sellDate));
      for (var h in histories) {
        newJson += "${jsonEncode(h.toJson())},";
      }
      newJson = newJson.replaceRange(newJson.length - 1, null, "]");
      await File(await _database).writeAsString(newJson);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<History>> getAll() async {
    String json = await File(await _database).readAsString();
    List<History> list = jsonToObject(json);
    return list;
  }

  List<History> jsonToObject(String jsonData) {
    List<History> listOf = (jsonDecode(jsonData) as List)
        .map((e) => History.fromJson(e))
        .toList();
    return listOf;
  }

  Future<bool> clearHistory() async {
    try {
      await File(await _database).writeAsString("[]");
      return true;
    } catch (e) {
      return false;
    }
  }
}
