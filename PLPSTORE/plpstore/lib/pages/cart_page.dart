import 'package:flutter/material.dart';
import 'package:plpstore/components/cart_item.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:plpstore/model/auth.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final item = cart.items.values.toList();
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: item.isEmpty
                ? const Center(child: Text('Carrinho Vazio!'))
                : ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (ctx, i) => CartItemWidget(item[i], cart),
                  ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.red,
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CartButton(cart: cart)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context);
    String user = token.getToken();
    return TextButton(
        onPressed: () {
          if(user == ''){
            Navigator.of(context).pushNamed(AppRoutes.login);
          }
          else {
            Navigator.of(context).pushNamed(AppRoutes.pedido);
          }
          
        },
        child: const Text('COMPRAR'));
  }
}
