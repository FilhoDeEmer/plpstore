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
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    double preco = double.parse(widget.data.valor);
    String precoFormat = preco.toStringAsFixed(2);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
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
                  Colors.black.withOpacity(0.15), BlendMode.dstATop)),
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
                width: 120,
                height: 160,
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
                  'Qnt.: ${widget.data.estoque.toString()}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (int.parse(widget.data.estoque) <= 0) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Produto fora de estoque ou com quantidade máxima atingida!'),
                          duration: Duration(seconds: 2),
                          action: null,
                        ),
                      );
                    } else {
                      cart.addItem(widget.data);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Produto adicionado com sucesso!'),
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
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: int.parse(widget.data.estoque) == 0
                          ? Colors.grey
                          : Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 7)),
                  child: const FaIcon(
                    FontAwesomeIcons.cartShopping,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
