import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/model/calculadora_frete.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/product.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final Product data;
  const ProductDetail({super.key, required this.data});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final cepController = MaskedTextController(mask: '00000-000');
  String frete = 'SEDEX';
  final List<String> list = ['SEDEX', 'PAC'];
  double valorFrete = 0;
  int index = 0;
  int addCar = 1;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context, listen: false);
    CalculadoraFrete calculadoraFrete = CalculadoraFrete();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data.nome,
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: deviceSize.width * 0.05,
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(deviceSize.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(deviceSize.width * 0.02),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.topCenter,
                    children: [
                      SizedBox(
                        width: deviceSize.width * 0.9,
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/img/tcg_card_back.jpg'),
                          image: NetworkImage(
                            'https://plpstore.com.br/img/produtos/${widget.data.imagem}',
                          ),
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/img/tcg_card_back.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.all(deviceSize.width * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green.withOpacity(0.6),
                          ),
                          child: Text(
                            'Reverse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceSize.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: deviceSize.width * 0.02),
              Card(
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(deviceSize.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'R\$${widget.data.valor}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: deviceSize.width * 0.06,
                            fontWeight: FontWeight.bold),
                      ),
                      Text('Estq.: ${widget.data.estoque}'),
                      SizedBox(height: deviceSize.width * 0.02),
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
                                  } else if (int.parse(widget.data.estoque) <=
                                      0) {
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: deviceSize.width * 0.1,
                                        vertical: deviceSize.width * 0.03)),
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
                          ),
                        ],
                      ),
                      if (int.parse(widget.data.estoque) != 0)
                        SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 60,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: cepController,
                                    decoration: InputDecoration(
                                      labelText: 'CEP',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: deviceSize.width * 0.02),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
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
                          padding: EdgeInsets.all(deviceSize.width * 0.02),
                          child: ElevatedButton(
                            child: const Text('Calcular'),
                            onPressed: () async {
                              try {
                                final valor =
                                    await calculadoraFrete.calcularFrete(
                                        cepController.text,
                                        widget.data.valor,
                                        frete);
                                setState(() {
                                  valorFrete = valor;
                                });
                              } catch (e) {
                              }
                            },
                          ),
                        ),
                      if (valorFrete != 0)
                        Text('Frete: ${valorFrete.toStringAsFixed(2)}')
                    ],
                  ),
                ),
              ),
              SizedBox(height: deviceSize.width * 0.02),
              Card(
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(deviceSize.width * 0.02),
                  child: Text(
                    widget.data.descricaoLonga,
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.04,
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


}
