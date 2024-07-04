import 'package:flutter/material.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/product.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatefulWidget {
  final Product data;
  final String colecao;
  final String idColection;
  const ProductGridItem({super.key, required this.data, required this.colecao, required this.idColection});

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    double preco = double.parse(widget.data.valor);
    String precoFormat = preco.toStringAsFixed(2);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: _isLoading
                ? const AssetImage('assets/img/tcg_card_back.jpg')
                    as ImageProvider<Object>
                : NetworkImage(
                    "https://dz3we2x72f7ol.cloudfront.net/expansions/${widget.colecao}/pt-br/${widget.idColection}_PTBR_${widget.data.numero}.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.dstATop)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.data.nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            'Cod.: ${widget.data.imagem}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'Preço: R\$$precoFormat',
            style: const TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
          ),
          Text(
            'Qnt.: ${widget.data.estoque.toString()}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
                          action: null),
                    );
                  } else {
                    cart.addItem(widget.data);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Produto adicionado com sucesso!'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'DESFAZER',
                          onPressed: () {
                            cart.removeSingleItem(widget.data.nome);
                          },
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        int.parse(widget.data.estoque) == 0 ? Colors.grey : Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10)),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
