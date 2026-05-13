import 'dart:convert';

class Product {
  final String barCode;
  final String productName;
  final double productPrice;

  Product({
    required this.barCode,
    required this.productName,
    required this.productPrice,
  });

  Map<String, dynamic> toJson() => {
    'barcode': barCode,
    'product_name': productName,
    'product_price': productPrice,
  };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barCode: json['barcode'],
      productName: json['product_name'],
      productPrice: json['product_price'],
    );
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) || other is Product && other.barCode == barCode;

  @override
  int get hashCode => barCode.hashCode;

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
