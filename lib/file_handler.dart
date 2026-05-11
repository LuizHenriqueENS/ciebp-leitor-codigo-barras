import 'dart:convert';
import 'dart:io';
import 'package:ciebp_leitor/products.dart';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<String> get _database async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/data.json";

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

  Future<bool> saveProduct(Product newProduct) async {
    String oldFile = await File(await _database).readAsString();
    var list = (jsonDecode(oldFile) as List)
        .map((e) => Product.fromJson(e))
        .toList();

    for (Product p in list) {
      if (newProduct.barCode == p.barCode) {
        return false;
      }
    }

    list.add(
      Product(
        barCode: newProduct.barCode,
        productName: newProduct.productName,
        productPrice: newProduct.productPrice,
      ),
    );

    String toJson = "[ ";
    for (Product p in list) {
      toJson += "${jsonEncode(p.toJson())},";
    }
    toJson = toJson.replaceRange(toJson.length - 1, null, "]");

    try {
      await File(await _database).writeAsString(toJson);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(Product product) async {
    String oldFile = await File(await _database).readAsString();
    List<Product> list = (jsonDecode(oldFile) as List)
        .map((e) => Product.fromJson(e))
        .toList();

    Product? removebleObj;
    for (Product p in list) {
      if (p.barCode == product.barCode) {
        removebleObj = p;
      }
    }

    if (removebleObj != null) {
      list.remove(removebleObj);
    } else {
      return false;
    }

    String toJson = "[ ";
    for (Product p in list) {
      toJson += "${jsonEncode(p.toJson())},";
    }
    toJson = toJson.replaceRange(toJson.length - 1, null, "]");

    try {
      await File(await _database).writeAsString(toJson);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Product>> findAll() async {
    String content = await File(await _database).readAsString();

    var list = (jsonDecode(content) as List)
        .map((e) => Product.fromJson(e))
        .toList();

    return list;
  }

  Future<Product?> findByBarcode(String barcode) async {
    List<Product> allProducts = await findAll();

    for(Product p in allProducts){
      if(p.barCode == barcode){
        return p;
      }
    }

    return null;
  }

  void deleteAll() async {
    await File(await _database).delete();
    await File(await _database).writeAsString("[]");
  }
}



  // Future<File> get createFile async {
  //   final path = await _localPath;
  //   return File('$path/counter.txt');
  // }

  // Future<File> writeCounter(int counter) async{
  //   final file = await createFile;
  //
  //   return file.writeAsString("$counter");
  // }

  // Future<String> readCounter() async {
  //   try{
  //     final file = await createFile;
  //
  //     final contents = await file.readAsString();
  //     print(contents);
  //     return contents;
  //   } catch (e) {
  //     print(e);
  //     return "_";
  //   }
  // }
