import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/cart_item.dart';
import 'package:plpstore/model/gerar_pedido.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  final List<String> envio = <String>['PAC', 'Sedex', 'Retirar no Local'];
  String? _tipoEnvio;
  double valorFrete = 0;
  double valorTotal = 0;
  double valorPedido = 0;

  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final cepController = MaskedTextController(mask: '00000-000');
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final complementoController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final observacaoController = TextEditingController();
  final numeroController = TextEditingController();

  void calcularValor() {
    setState(() {
      valorTotal = valorPedido + valorFrete;
    });
  }

  late bool _isFirstTime;

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<Auth>(context, listen: false);
    await Provider.of<GetCliente>(context, listen: false)
        .pegaClients(userProvider.getCpf());

    if (mounted) {
      setState(() {
        final cliente = Provider.of<GetCliente>(context, listen: false).cliente;
        if (cliente != null) {
          nomeController.text = (cliente.nome != 'null') ? cliente.nome : '';
          cpfController.text = (cliente.cpf != 'null') ? cliente.cpf : '';
          phoneController.text =
              (cliente.telefone != '(') ? cliente.telefone : '';
          emailController.text = (cliente.email != 'null') ? cliente.email : '';
          ruaController.text = (cliente.rua != 'null') ? cliente.rua : '';
          bairroController.text =
              (cliente.bairro != 'null') ? cliente.bairro : '';
          complementoController.text =
              (cliente.complemento != 'null') ? cliente.complemento : '';
          cidadeController.text =
              (cliente.cidade != 'null') ? cliente.cidade : '';
          estadoController.text =
              (cliente.estado != 'null') ? cliente.estado : '';
          cepController.text = (cliente.cep != 'null') ? cliente.cep : '';
          numeroController.text =
              (cliente.numero != 'null') ? cliente.numero : '';
          _isFirstTime = cliente.fistTime;
        }
      });
    }
  }

  String? _envioError;
  void _finalizarPedido() {
    setState(() {
      _envioError = _tipoEnvio == null ? 'Selecione um tipo de envio' : null;
    });
    if (!_formKey.currentState!.validate() || _tipoEnvio == null) {
      return;
    }
    final userProvider = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    final List<Map<String, dynamic>> produtos = cart.items.values.map((item) {
      return {
        'id_produto': item.productCod,
        'quantidade': item.quantity,
        'combo': item.combo,
      };
    }).toList();
    final random = Random();
    final randomNumber = random.nextInt(1500);
    final now = DateTime.now();
    final dateFormat = DateFormat('dd-MM-yyyy-HH:mm:ss');
    final sessao = '${dateFormat.format(now)}-$randomNumber';

    final Map<String, dynamic> pedido = {
      'id_user': userProvider.getUserId(),
      'produtos': produtos,
      'sessao': sessao,
      'sub_total': valorPedido,
      'frete' : valorFrete,
      'total' : valorTotal,
      'pgto_entrega' : _tipoEnvio == 'Retirar no Local' ? 'Sim' : 'Não',
      'tipo_frete': _tipoEnvio == 'Retirar no Local' ? '' : _tipoEnvio,
    };

    final String pedidoJson = jsonEncode(pedido);

    if (_isFirstTime) {
      print(pedidoJson);
      // é a primeira vez
      GerarPedido gerarPedido = GerarPedido();
      gerarPedido.gerarPedido(pedidoJson);
    } else {
      // não é a primeira compra
      GerarPedido gerarPedido = GerarPedido();
      gerarPedido.gerarPedido(pedidoJson);
    }
    // chamada da url passando o pedidoJson e tambem tem que verificar se _isFisrtTime é true para salvar os dados do cliente
    // tambem pode ser adicionado uma mensagem de verificação para perguntar se deseja salvar o novo endereço
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    valorPedido = cart.totalAmount;
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProductsCard(constraints, items),
                _buildDeliveryInfoCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsCard(BoxConstraints constraints, List<CartItem> items) {
    return SizedBox(
      width: double.infinity,
      height: constraints.maxHeight * 0.4,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Produtos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      title: Text(items[i].name),
                      leading: Text('${items[i].quantity}x'),
                      trailing: Text(items[i].price.toStringAsFixed(2)),
                    );
                  },
                ),
              ),
              FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  'Pedido: ${valorPedido.toStringAsFixed(2)} Frete: ${valorFrete.toStringAsFixed(2)} Total: ${valorTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11) {
      return false;
    }

    if (cpf == '00000000000' ||
        cpf == '11111111111' ||
        cpf == '22222222222' ||
        cpf == '33333333333' ||
        cpf == '44444444444' ||
        cpf == '55555555555' ||
        cpf == '66666666666' ||
        cpf == '77777777777' ||
        cpf == '88888888888' ||
        cpf == '99999999999') {
      return false;
    }

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int primeiroDigito = (soma * 10) % 11;
    if (primeiroDigito == 10) {
      primeiroDigito = 0;
    }

    if (int.parse(cpf[9]) != primeiroDigito) {
      return false;
    }

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int segundoDigito = (soma * 10) % 11;
    if (segundoDigito == 10) {
      segundoDigito = 0;
    }

    if (int.parse(cpf[10]) != segundoDigito) {
      return false;
    }

    return true;
  }

  Widget _buildDeliveryInfoCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Informações de Entrega',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildTextField(nomeController, 'Nome Completo*', (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Nome é Obrigatório';
                  }
                  return null;
                }),
                _buildDoubleTextField(
                    cpfController,
                    'CPF*',
                    (value) {
                      if (value!.isEmpty || value.trim().length < 11) {
                        return 'CPF está inválido';
                      }
                      return null;
                    },
                    phoneController,
                    'Telefone*',
                    (value) {
                      if (value!.isEmpty) {
                        return 'Telefone é obrigatório!';
                      }
                      return null;
                    }),
                _buildTextField(emailController, 'E-mail*', (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                }),
                _buildDoubleTextField(
                    cepController,
                    'CEP*',
                    (value) {
                      if (value!.isEmpty) {
                        return 'CEP é obrigatório!';
                      }
                      return null;
                    },
                    numeroController,
                    'Número*',
                    (value) {
                      if (value!.isEmpty) {
                        return 'Número é obrigatório!';
                      }
                      return null;
                    }),
                _buildTextField(ruaController, 'Rua*', (value) {
                  if (value!.isEmpty) {
                    return 'Rua é obrigatório';
                  }
                  return null;
                }),
                _buildTextField(bairroController, 'Bairro*', (value) {
                  if (value!.isEmpty) {
                    return 'Bairro é obrigatório';
                  }
                  return null;
                }),
                _buildTextField(complementoController, 'Complemento', (value) {
                  return null;
                }),
                _buildTextField(cidadeController, 'Cidade*', (value) {
                  if (value!.isEmpty) {
                    return 'Cidade é obrigatório';
                  }
                  return null;
                }),
                _buildTextField(estadoController, 'Estado*', (value) {
                  if (value!.isEmpty) {
                    return 'Estado é obrigatório';
                  }
                  return null;
                }),
                _buildTextField(observacaoController, 'Observações', (value) {
                  return null;
                }),
                _buildShippingDropdown(),
                if (_envioError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _envioError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const Text('Valor do frete'),
                Text('Valor Total: ${valorTotal.toStringAsFixed(2)}'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _finalizarPedido();
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.green),
                        padding: MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 6),
                        ),
                      ),
                      child: const Text(
                        'Finalizar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String? Function(String?)? validator) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget _buildDoubleTextField(
      TextEditingController controller1,
      String labelText1,
      String? Function(String?)? validator1,
      TextEditingController controller2,
      String labelText2,
      String? Function(String?)? validator2) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextFormField(
              controller: controller1,
              validator: labelText1 != 'CPF*'
                  ? validator1
                  : (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (!validarCPF(value)) {
                        return 'CPF inválido';
                      }
                      return null;
                    },
              decoration: InputDecoration(
                labelText: labelText1,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: controller2,
              validator: validator2,
              decoration: InputDecoration(
                labelText: labelText2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingDropdown() {
    return Row(
      children: [
        const Text('Frete:'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            hint: const Text('Selecione o tipo de envio'),
            value: _tipoEnvio,
            items: envio.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? novoValor) {
              setState(() {
                _tipoEnvio = novoValor;
                valorFrete = _tipoEnvio == 'PAC'
                    ? 22.0
                    : _tipoEnvio == 'Sedex'
                        ? 30.0
                        : 0.0;
                calcularValor();
              });
            },
          ),
        ),
      ],
    );
  }
}
