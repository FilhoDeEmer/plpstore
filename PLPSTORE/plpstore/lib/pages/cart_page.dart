import 'package:flutter/material.dart';
import 'package:plpstore/components/cart_item.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:plpstore/model/auth.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'Carrinho Vazio!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(177, 136, 2, 1),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => CartItemWidget(items[i], cart),
                  ),
          ),
          _buildTotalCard(cart),
        ],
      ),
    );
  }

  Widget _buildTotalCard(Cart cart) {
    return Card(
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
              'Total:',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Chip(
              backgroundColor: Color.fromRGBO(179, 146, 41, 1),
              label: Text(
                'R\$${cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            if (cart.itemsCount > 0) 
              CartButton(cart: cart),
          ],
        ),
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
    final userToken = token.getToken();

    return TextButton(
      onPressed: () {
        if (userToken.isEmpty) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.pedido);
        }
      },
      child: const Text(
        'COMPRAR',
        style: TextStyle(color: Color.fromRGBO(177, 136, 2, 1)),
      ),
    );
  }
}
