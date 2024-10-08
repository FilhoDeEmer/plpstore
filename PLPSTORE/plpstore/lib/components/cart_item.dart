import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/cart_item.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Cart cart;

  const CartItemWidget(this.cartItem, this.cart, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String totalUni = NumberFormat.currency(locale: 'pt-BR', symbol: 'R\$')
        .format(cartItem.price * cartItem.quantity);
    String precoUni = NumberFormat.currency(locale: 'pt-BR', symbol: 'R\$')
        .format(cartItem.price);
    return Dismissible(
      key: ValueKey(cartItem.productCod),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tem Certeza?'),
            content: const Text('Quer remover o item do carrinho?'),
            actions: [
              TextButton(
                child: const Text('Não'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: const Text('Sim'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(cartItem.productCod);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            
            title: Text('${cartItem.name} ${cartItem.productCod}'),
            subtitle: Row(
              children: <Widget>[
                Text('Uni.: $precoUni'),
                IconButton(
                    onPressed: () => _decrementQuantity(context),
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    )),
                Text('${cartItem.quantity}x'),
                IconButton(
                    onPressed: () => _incrementQuantity(context),
                    icon: const Icon(Icons.add, color: Colors.blue)),
              ],
            ),
            trailing: Text(totalUni),
          ),
        ),
      ),
    );
  }

  void _incrementQuantity(BuildContext context) {
      Provider.of<Cart>(context, listen: false).updateProduct(cartItem);
  }

  void _decrementQuantity(BuildContext context) {
    if (cartItem.quantity > 1) {
      Provider.of<Cart>(context, listen: false)
          .removeSingleItem(cartItem.productCod);
    } else {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Tem Certeza?'),
          content: const Text('Quer remover o item do carrinho?'),
          actions: [
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(ctx).pop(true);
                Provider.of<Cart>(
                  context,
                  listen: false,
                ).removeItem(cartItem.productCod);
              },
            ),
          ],
        ),
      );
    }
  }
}
