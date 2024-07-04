class CartItem {
  final String productCod;
  final String name;
  final String combo = 'Não';// ou Sim
  final int quantity;
  final double price;
  final int qntMax;

  CartItem({
    required this.productCod,
    required this.name,
    required this.quantity,
    required this.price,
    required this.qntMax,
  });
}