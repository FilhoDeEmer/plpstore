class CartItem {
  final String id;
  final String productCod;
  final String name;
  final int quantity;
  final double price;
  final int qntMax;

  CartItem({
    required this.id,
    required this.productCod,
    required this.name,
    required this.quantity,
    required this.price,
    required this.qntMax,
  });
}