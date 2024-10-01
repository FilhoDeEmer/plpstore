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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetail(data: widget.data),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = width * 1.33;
          double imageHeight =
              height * 0.6; 
          double textSize = width * 0.08; 
          double padding = width * 0.02; 

          return Container(
            padding:
                EdgeInsets.symmetric(vertical: padding, horizontal: padding),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: const AssetImage('assets/img/tcg_card_back.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.15),
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      widget.data.nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(padding),
                    width: width * 0.8,
                    height: imageHeight,
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.topCenter,
                      children: [
                        FadeInImage(
                          placeholder:
                              const AssetImage('assets/img/tcg_card_back.jpg'),
                          image: NetworkImage(
                            'URL da imagem',
                          ),
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/img/tcg_card_back.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        Positioned(
                          bottom: 5,
                          left: 10,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.withOpacity(0.6),
                            ),
                            child: Text(
                              'Reverse',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'R\$${precoFormat}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.08,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Estq.: ${widget.data.estoque.toString()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.08,
                      ),
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
                          padding: EdgeInsets.all(
                              width * 0.03), 
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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
