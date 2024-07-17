import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/badgee.dart';
import 'package:plpstore/components/bottom_navigator.dart';
import 'package:plpstore/model/auth.dart';
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context, listen: false);
    final token = Provider.of<Auth>(context);
    String user = token.getToken();
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.data.nome, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const FaIcon(FontAwesomeIcons.cartShopping),
            ),
            builder: (context, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
          PopupMenuButton(
            icon: const FaIcon(FontAwesomeIcons.solidCircleUser),
            itemBuilder: (_) => [
              PopupMenuItem(
                child:
                    user.isEmpty ? const Text('Entrar') : const Text('Perfil'),
                onTap: () => user.isEmpty
                    ? Navigator.of(context).pushNamed(AppRoutes.login)
                    : Navigator.of(context).pushNamed(AppRoutes.perfil),
              ),
              const PopupMenuItem(child: Text('Meus Pedidos')),
              if (user.isNotEmpty)
                PopupMenuItem(
                  child: const Text('Sair'),
                  onTap: () {
                    token.logout();
                  },
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                    image: NetworkImage(
                        'https://plpstore.com.br/img/produtos/${widget.data.imagem}')),
              ),
              Column(
                children: [
                  Text(
                    widget.data.descricao,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Preço: R\$${widget.data.valor}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  Text('Estq.: ${widget.data.estoque}'),
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
                  if (int.parse(widget.data.estoque) != 0)
                    Container(
                      padding: const EdgeInsets.all(10),
                      // height: 70,
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
                                  // hint: const Text('Selecione o tipo de frete'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (int.parse(widget.data.estoque) != 0)
                    ElevatedButton(
                      child: const Text('Calcular'),
                      onPressed: () {
                        setState(() {
                          valorFrete =
                              22.00; // aqui vai a calculo do frete pela api do correios
                        });
                      },
                    ),
                  if (valorFrete != 0)
                    Text('Frete: ${valorFrete.toStringAsFixed(2)}')
                ],
              ),
              Padding(
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
              const Image(
                image: AssetImage('assets/img/mercadopagologo.png'),
                width: 200,
                height: 100,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottonNavigator(
        currentIndex: 2,
        onTap: (int i) {
          setState(() {
            index = i;
          });
          _navigateToPage(i, context);
        },
      ),
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
      case 1:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
      case 2:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
      case 3:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
    }
  }
}
