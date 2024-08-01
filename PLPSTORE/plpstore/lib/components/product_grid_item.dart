import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/product.dart';
import 'package:plpstore/pages/product_detail_page.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatefulWidget {
  final Product data;
  const ProductGridItem({super.key, required this.data});

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  int addCar = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    double preco = double.parse(widget.data.valor);
    String precoFormat = preco.toStringAsFixed(2);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductDetail(data: widget.data),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: const AssetImage('assets/img/tcg_card_back.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.15), BlendMode.dstATop),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.data.nome,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 100,
                height: 140,
                child: FadeInImage(
                  placeholder: const AssetImage('assets/img/tcg_card_back.jpg'),
                  image: NetworkImage(
                      'https://plpstore.com.br/img/produtos/${widget.data.imagem}'),
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/img/tcg_card_back.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'R\$$precoFormat',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Estq.: ${widget.data.estoque.toString()}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _decrementQuantity(context),
                        icon: const FaIcon(
                          FontAwesomeIcons.minus,
                          color: Colors.red,
                        ),
                      ),
                      Text(addCar.toString()),
                      IconButton(
                        onPressed: () => _incrementQuantity(context),
                        icon: const FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    child: RawMaterialButton(
                      onPressed: () {
                        if (widget.data.estoque == addCar) {
                          messageFail(context);
                        } else if (int.parse(widget.data.estoque) <= 0) {
                          messageFail(context);
                        } else {
                          cart.addItemMax(widget.data, addCar);
                          messageSuccess(context, cart);
                        }
                      },
                      elevation: 2,
                      fillColor: int.parse(widget.data.estoque) <= 0
                          ? Colors.grey
                          : Colors.green,
                      child: const FaIcon(
                        FontAwesomeIcons.cartShopping,
                        size: 14,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15),
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void messageSuccess(BuildContext context, Cart cart) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Produto adicionado com sucesso!'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            cart.removeSingleItem(widget.data.id);
          },
        ),
      ),
    );
  }

  void messageFail(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Produto fora de estoque ou com quantidade máxima atingida!'),
        duration: Duration(seconds: 2),
        action: null,
      ),
    );
  }

  void _incrementQuantity(BuildContext context) {
    setState(() {
      if (addCar < int.parse(widget.data.estoque)) {
        addCar++;
      }
    });
  }

  void _decrementQuantity(BuildContext context) {
    setState(() {
      if (addCar > 1) {
        addCar--;
      }
    });
  }
}
