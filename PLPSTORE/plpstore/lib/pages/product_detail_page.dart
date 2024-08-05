import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/bottom_navigator.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/product.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final Product data;
  const ProductDetail({super.key, required this.data});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final cepController = MaskedTextController(mask: '00000-000');
  String? frete = 'SEDEX';
  final List<String> list = ['SEDEX', 'PAC'];
  double valorFrete = 0;
  int index = 0;
  int addCar = 1;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.data.nome, style: const TextStyle(color: Color.fromARGB(255, 153, 143, 0))),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 153, 143, 0)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 239, 0, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.home, arguments: 1);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                      image: NetworkImage(
                          'https://plpstore.com.br/img/produtos/${widget.data.imagem}')),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 8,
                child: Column(
                  children: [
                    Text(
                      'R\$${widget.data.valor}',
                      style: const TextStyle(color: Colors.black, fontSize: 26),
                    ),
                    Text('Estq.: ${widget.data.estoque}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            child: ElevatedButton(
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
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      int.parse(widget.data.estoque) <= 0
                                          ? Colors.grey
                                          : Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10)),
                              child: const FaIcon(
                                FontAwesomeIcons.cartShopping,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Image(
                          image: AssetImage('assets/img/mercadopagologo.png'),
                          width: 100,
                          height: 50,
                        )
                      ],
                    ),
                    if (int.parse(widget.data.estoque) != 0)
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 70,
                        width: deviceSize.width * 0.80,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 60,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: cepController,
                                  decoration:
                                      const InputDecoration(labelText: 'CEP'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 60,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: frete,
                                    items: list.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        frete = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (int.parse(widget.data.estoque) != 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text('Calcular'),
                          onPressed: () {
                            setState(() {
                              valorFrete =
                                  22.00; // aqui vai a calculo do frete pela api do correios
                            });
                          },
                        ),
                      ),
                    if (valorFrete != 0)
                      Text('Frete: ${valorFrete.toStringAsFixed(2)}')
                  ],
                ),
              ),
              Card(
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.data.descricaoLonga,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.justify,
                    locale: const Locale('pt', 'BR'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigator(
        currentIndex: 1,
        onTap: (int i) {
          setState(() {
            index = i;
          });
          _navigateToPage(i, context);
        },
        cartItemCount: cart.itemsCount,
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

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: index);
        break;
      case 1:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: index);
        break;
      case 2:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: index);
        break;
      case 3:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: index);
        break;
    }
  }
}
