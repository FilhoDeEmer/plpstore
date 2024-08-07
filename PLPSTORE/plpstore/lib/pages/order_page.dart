import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/components/validar_cpf.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/calculadora_frete.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/cart_item.dart';
import 'package:plpstore/model/gerar_pedido.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final ValidarCpf validarCpf = ValidarCpf();
  final List<String> envio = <String>['PAC', 'SEDEX', 'Retirar no Local'];
  String? _tipoEnvio;
  double valorFrete = 0;
  double valorTotal = 0;
  double valorPedido = 0;
  CalculadoraFrete calculadoraFrete = CalculadoraFrete();

  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final cepController = MaskedTextController(mask: '00000-000');
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final complementoController = TextEditingController();
  final cidadeController = TextEditingController();
  final observacaoController = TextEditingController();
  final numeroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  bool erro = false;
  Future<void> _loadUserData() async {
    try {
      final userProvider = Provider.of<Auth>(context, listen: false);
      await Provider.of<GetCliente>(context, listen: false)
          .pegaClients(userProvider.getCpf());

      final cliente = Provider.of<GetCliente>(context, listen: false).cliente;
      if (cliente != null) {
        setState(() {
          nomeController.text = cliente.nome;
          cpfController.text = cliente.cpf;
          phoneController.text = cliente.telefone;
          emailController.text = cliente.email;
          ruaController.text = cliente.rua;
          bairroController.text = cliente.bairro;
          cidadeController.text = cliente.cidade;
          _selectedState = cliente.estado;
          cepController.text = cliente.cep;
          numeroController.text = cliente.numero;
        });
      }
    } catch (e) {
      // Handle error
      print('Erro ao carregar dados do cliente: $e');
    }
  }

  Future<void> _launchInWebViewWithoutDomStorage(String url) async {
    Navigator.of(context).popAndPushNamed(AppRoutes.checkout, arguments: url);
  }

  String? _selectedState;
  final List<String> _states = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  String? _envioError;
  bool _isLoading = false;
  Future<void> _finalizarPedido(BuildContext context) async {
    setState(() {
      _envioError = _tipoEnvio == null ? 'Selecione um tipo de envio' : null;
    });

    if (!_formKey.currentState!.validate() || _tipoEnvio == null) {
      erro = true;
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
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
        'frete': valorFrete,
        'total': valorTotal,
        'pgto_entrega': _tipoEnvio == 'Retirar no Local' ? 'Sim' : 'Não',
        'tipo_frete': _tipoEnvio == 'Retirar no Local' ? '' : _tipoEnvio,
      };

      final String pedidoJson = jsonEncode(pedido);
      final gerarPedido = GerarPedido();

      final response = await gerarPedido.gerarPedido(pedidoJson);
      final int? saleId = int.tryParse(response);

      if (saleId != null) {
        final urlPayment = await gerarPedido.criarPreferencia(
            valorTotal, userProvider.getUserId(), saleId.toString());
        if (urlPayment['id_payment'] != 'fail') {
          await _launchInWebViewWithoutDomStorage(
              urlPayment['test_init_point']!);
        }
        cart.clean();
      }
    } catch (e) {
      print('Erro ao finalizar pedido: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        valorPedido = cart.totalAmount;
        final items = cart.items.values.toList();

        return Consumer<Auth>(
          builder: (context, userProvider, child) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(AppRoutes.home, arguments: 2);
                  },
                ),
                iconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.tertiary),
                toolbarHeight: 80,
                title: Text('Pedido',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).appBarTheme.backgroundColor!,
                        Theme.of(context).appBarTheme.foregroundColor!,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                centerTitle: true,
              ),
              body: _isLoading
                  ? Center(
                      child: PokeballLoading(),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildProductsCard(constraints, items),
                              _buildDeliveryInfoCard(context),
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductsCard(BoxConstraints constraints, List<CartItem> items) {
    return SizedBox(
      width: double.infinity,
      height: constraints.maxHeight * 0.4,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Produtos',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    return ListTile(
                      title: Text(item.name),
                      leading: Text('${item.quantity}x'),
                      trailing: Text(item.price.toStringAsFixed(2)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Total: R\$ ${valorPedido.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoCard(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Informações de Entrega',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
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
                    if (value!.isEmpty || !validarCpf.validarCPF(value)) {
                      return 'CPF inválido';
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
                  },
                ),
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
                  },
                ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Estado',
                    ),
                    value: _selectedState,
                    hint: Text('UF*'),
                    isDense: true,
                    menuMaxHeight: 300,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                    items: _states.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione o estado';
                      }
                      return null;
                    },
                  ),
                ),
                _buildTextField(cidadeController, 'Cidade*', (value) {
                  if (value!.isEmpty) {
                    return 'Cidade é obrigatório';
                  }
                  return null;
                }),
                _buildTextField(observacaoController, 'Observações', (value) {
                  return null;
                }),
                _buildShippingDropdown(valorTotal.toString()),
                Text('Valor do frete: ${valorFrete.toStringAsFixed(2)}'),
                Text('Valor Total: ${valorTotal.toStringAsFixed(2)}'),
                if (erro)
                  Text(
                    'Campo obrigatório*',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _finalizarPedido(context);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
        ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextFormField(
                controller: controller1,
                validator: validator1,
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
      ),
    );
  }

  Widget _buildShippingDropdown(String valorTotal) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Tipo de Envio',
            errorText: _envioError, // Exibe mensagem de erro, se houver
          ),
          hint: const Text('Selecione o tipo de envio'),
          value: _tipoEnvio,
          items: envio.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              setState(() {
                _tipoEnvio = newValue;
              });

              try {
                final valor = await calculadoraFrete.calcularFrete(
                  cepController.text,
                  valorTotal.toString(),
                  _tipoEnvio!, // Use o valor selecionado
                );
                setState(() {
                  valorFrete = valor;
                });
              } catch (e) {
                //print('Erro ao calcular frete: $e');
                setState(() {
                  valorFrete = 0.0; // Defina um valor padrão ou trate o erro adequadamente
                  _envioError = 'Não foi possível calcular o frete'; // Exiba mensagem de erro se necessário
                });
              }
            }
          },
        ),
      ),
    ],
  );
}

}
