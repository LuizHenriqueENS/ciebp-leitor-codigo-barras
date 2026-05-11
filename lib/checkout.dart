import 'package:ciebp_leitor/products.dart';

class Checkout {
  int quantity = 0;
  late Product product;
  double sum = 0;

  Checkout (this.product){
    addProduct(product);
  }

  void addProduct(Product prod) {
    quantity++;
    sum = product.productPrice * quantity;
  }
}
