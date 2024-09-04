import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
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
  bool _gerandoPedido = false;

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

  bool _isLoading = true; // Inicialmente, o carregamento está ativo

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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
    } finally {
      // Garanta que _isLoading seja definido como false quando a carga for concluída
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchInWebViewWithoutDomStorage(String url) async {
    Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: 3);
    try {
      await launchUrl(
        Uri.parse(url),
      );
    } catch (e) {
      throw 'Não foi possível acessar $url';
    }
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
  bool erro = false;

  Future<void> _finalizarPedido(Cart cart, Auth userProvider) async {
    setState(() {
      _envioError = _tipoEnvio == null ? 'Selecione um tipo de envio' : null;
    });

    if (!_formKey.currentState!.validate() || _tipoEnvio == null) {
      setState(() {
        _gerandoPedido = false;
      });
      erro = true;
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<Auth>(context, listen: false);

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
        'total': valorFrete + valorPedido,
        'pgto_entrega': _tipoEnvio == 'Retirar no Local' ? 'Sim' : 'Não',
        'tipo_frete': _tipoEnvio == 'Retirar no Local' ? '' : _tipoEnvio,
      };

      final String pedidoJson = jsonEncode(pedido);
      final gerarPedido = GerarPedido();

      final response = await gerarPedido.gerarPedido(pedidoJson);
      final int? saleId = int.tryParse(response);

      if (saleId != null) {
        final urlPayment = await gerarPedido.criarPreferencia(
            (valorPedido + valorFrete),
            userProvider.getUserId(),
            saleId.toString());
        if (urlPayment['id_payment'] != 'fail') {
          await _launchInWebViewWithoutDomStorage(urlPayment['init_point']!);
        }
        cart.clean();
      }
    } catch (e) {
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
                              _buildDeliveryInfoCard(
                                  context, cart, userProvider),
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
      width: 400,
      height: 300,
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
                  child: Text(
                    'Produtos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (ctx, i) => Divider(
                      height: 1,
                      thickness: 1,
                      color:
                          Colors.grey.shade300), // Divisores com altura menor
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal:
                              8.0), // Reduz o padding interno do ListTile
                      title: Text(item.name,
                          style: TextStyle(
                              fontSize:
                                  14)), // Ajusta o tamanho da fonte para reduzir o espaço
                      leading: Text('${item.quantity}x',
                          style: TextStyle(
                              fontSize: 14)), // Ajusta o tamanho da fonte
                      trailing: Text(item.price.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 14)), // Ajusta o tamanho da fonte
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

  Widget _buildDeliveryInfoCard(
      BuildContext context, Cart cart, Auth userPovider) {
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
                _buildShippingDropdown(valorPedido.toString()),
                Text('Valor do frete: ${valorFrete.toStringAsFixed(2)}'),
                Text(
                    'Valor Total: ${(valorPedido + valorFrete).toStringAsFixed(2)}'),
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
                    child: _gerandoPedido
                        ? PokeballLoading()
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _gerandoPedido = true;
                              });
                              _finalizarPedido(cart, userPovider);
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

  Widget _buildShippingDropdown(String valorCompra) {
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
                    valorTotal = (double.parse(valorCompra) + valorFrete);
                  });
                } catch (e) {
                  setState(() {
                    valorFrete =
                        0.0; // Defina um valor padrão ou trate o erro adequadamente
                    _envioError =
                        'Não foi possível calcular o frete'; // Exiba mensagem de erro se necessário
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
