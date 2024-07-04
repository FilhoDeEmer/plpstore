import 'package:flutter/material.dart';
import 'package:plpstore/components/cart_item.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/order_list.dart';
import 'package:provider/provider.dart';

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
          Expanded(
            child: ListView.builder(
              itemCount: item.length,
              itemBuilder: (ctx, i) => CartItemWidget(item[i], cart),
            ),
          )
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
    ?
    const CircularProgressIndicator()
    : TextButton(
      onPressed: widget.cart.itemsCount == 0
      ? null
      :() async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<OrderList>(
          context, listen: false,
        ).addOrder(widget.cart);

        widget.cart.clean();
        setState(() {
          _isLoading = false;
        });
      }, 
      child: const Text('COMPRAR'));
  }
}