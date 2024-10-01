import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/cliente.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:plpstore/components/funcao_externas.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late Future<void> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<Auth>(context, listen: false);
    await Provider.of<GetCliente>(context, listen: false)
        .pegaClients(userProvider.getCpf());
  }

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    final cart = Provider.of<Cart>(context);
    final clienteProvider = Provider.of<GetCliente>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<void>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    PokeballLoading()); 
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados'));
          } else {
            Cliente? cliente = clienteProvider.cliente;
            if (cliente == null) {
              return Center(child: Text('Dados do cliente não encontrados'));
            }
            return cliente.cpf.isEmpty
                ? _buildLoginPrompt()
                : FutureBuilder<List<dynamic>>(
                    future: Provider.of<GetCliente>(context, listen: false)
                        .pegarPedidos(user.getUserId()),
                    builder: (context, pedidosSnapshot) {
                      if (pedidosSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: PokeballLoading());
                      } else if (pedidosSnapshot.hasError) {
                        return Center(child: Text('Erro ao carregar pedidos'));
                      } else {
                        final pedidos = pedidosSnapshot.data ?? [];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                _buildClientInfo(cliente),
                                _buildAddressInfo(context, cliente),
                                const SizedBox(height: 20),
                                _buildStatsGrid(pedidos),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildContactRow(
                                      icon: FontAwesomeIcons.instagram,
                                      iconColor: Colors.pink,
                                      text: '@plpstore_',
                                      onPressed: () =>
                                          FuncaoExterna().instagram(),
                                    ),
                                    _buildContactRow(
                                      icon: FontAwesomeIcons.whatsapp,
                                      iconColor: Colors.green,
                                      text: '(13) 9 9618-7797',
                                      onPressed: () =>
                                          FuncaoExterna().whatsApp(),
                                    ),
                                  ],
                                ),
                                _buildContactRow(
                                  icon: FontAwesomeIcons.envelope,
                                  iconColor: Colors.blue,
                                  text: 'adm@plpstore.com.br',
                                  onPressed: () {},
                                ),
                                _buildContactRow(
                                  icon: FontAwesomeIcons.globe,
                                  iconColor: Colors.blue,
                                  text: 'www.plpstore.com.br',
                                  onPressed: () => FuncaoExterna().site(),
                                ),
                                _buildLogoutButton(user, cart, cliente),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
          }
        },
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            child: Text(
              'Entre ou Cadastre-se',
              style: TextStyle(
                color: Color.fromRGBO(192, 148, 2, 1),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(List<dynamic> pedidos) {
    final totalPedidos = pedidos.length.toString();
    final pedidosPagos =
        pedidos.where((pedido) => pedido['pago'] == 'Sim').length.toString();
    final pedidosNaoPagos =
        pedidos.where((pedido) => pedido['pago'] == 'Não').length.toString();

    final aguardandoEntrega = pedidos
        .where((pedido) => pedido['pgto_entrega'] == 'Não')
        .length
        .toString();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildGridItem('Total de Pedidos', totalPedidos,
            Color.fromRGBO(176, 207, 255, 1), pedidos, 'energiadeagua.png'),
        _buildGridItem('Pedidos Pagos', pedidosPagos, Color(0xFFbaecb6),
            pedidos, 'energiadegrama.png'),
        _buildGridItem('Pedidos Não Pagos', pedidosNaoPagos, Color(0xFFFFB0B0),
            pedidos, 'energiadefogo.png'),
        _buildGridItem('Aguardando Entrega', aguardandoEntrega,
            Color(0xFFFDDEBA), pedidos, 'energiaderaio.jpeg'),
      ],
    );
  }

  Widget _buildGridItem(String label, String value, Color color,
      List<dynamic> pedidos, String img) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AppRoutes.orderDetail, arguments: pedidos);
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color.withOpacity(0.5),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/img/${img}',
                  opacity: const AlwaysStoppedAnimation(.2),
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20,),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(icon, color: iconColor),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildClientInfo(Cliente cliente) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Minhas Informações',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  FaIcon(FontAwesomeIcons.user),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text('Usuário: ${cliente.nome}'),
            Text('E-mail: ${cliente.email}'),
            Text('CPF: ${cliente.cpf}'),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfo(BuildContext context, Cliente cliente) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Endereço',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => editInfo(context, cliente),
                  icon: const FaIcon(FontAwesomeIcons.pen),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                'Telefone: ${cliente.telefone.isNotEmpty ? cliente.telefone : ''}'),
            Text(
                'Rua: ${cliente.rua.isNotEmpty && cliente.rua != 'null' ? cliente.rua : ''}'),
            Text(
                'Cidade: ${cliente.cidade.isNotEmpty && cliente.cidade != 'null' ? cliente.cidade : ''}'),
            Text(
                'Número: ${cliente.numero.isNotEmpty && cliente.numero != 'null' ? cliente.numero : ''}'),
            Text(
                'Estado: ${cliente.estado.isNotEmpty && cliente.estado != 'null' ? cliente.estado : ''}'),
            Text(
                'Bairro: ${cliente.bairro.isNotEmpty && cliente.bairro != 'null' ? cliente.bairro : ''}'),
            Text(
                'CEP: ${cliente.cep.isNotEmpty && cliente.cep != 'null' ? cliente.cep : ''}'),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(Auth user, Cart cart, Cliente cliente) {
    return Card(
      elevation: 8,
      color: Color.fromARGB(202, 250, 145, 145),
      child: ListTile(
        leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
        title: const Text(
          'Sair',
          style: TextStyle(color: Colors.red),
        ),
        iconColor: Colors.red,
        onTap: () {
          user.logout();
          cart.clean();
          cliente.deslogar();
          Navigator.of(context).popAndPushNamed(AppRoutes.home);
        },
      ),
    );
  }

  void editInfo(BuildContext context, Cliente cliente) {
    final phoneController = MaskedTextController(
      mask: '(00) 00000-0000',
      text: cliente.telefone.isNotEmpty && cliente.telefone != 'null'
          ? cliente.telefone
          : '',
    );
    final cepController = MaskedTextController(
      mask: '00000-000',
      text: cliente.cep.isNotEmpty && cliente.cep != 'null' ? cliente.cep : '',
    );

    final controllers = {
      'telefone': phoneController,
      'rua': TextEditingController(
          text: cliente.rua.isNotEmpty && cliente.rua != 'null'
              ? cliente.rua
              : ''),
      'bairro': TextEditingController(
          text: cliente.bairro.isNotEmpty && cliente.bairro != 'null'
              ? cliente.bairro
              : ''),
      'cidade': TextEditingController(
          text: cliente.cidade.isNotEmpty && cliente.cidade != 'null'
              ? cliente.cidade
              : ''),
      'numero': TextEditingController(
          text: cliente.numero.isNotEmpty && cliente.numero != 'null'
              ? cliente.numero
              : ''),
      'estado': TextEditingController(
          text: cliente.estado.isNotEmpty && cliente.estado != 'null'
              ? cliente.estado
              : ''),
      'cep': cepController,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Informações'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildFormFields(controllers),
                _buildStateDropdown(controllers['estado']!),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_validateFields(controllers)) {
                      cliente.atualizarEndereco(
                        telefone: controllers['telefone']!.text,
                        rua: controllers['rua']!.text,
                        cidade: controllers['cidade']!.text,
                        numero: controllers['numero']!.text,
                        estado: controllers['estado']!.text,
                        cep: controllers['cep']!.text,
                        bairro: controllers['bairro']!.text,
                      );
                      Provider.of<GetCliente>(context, listen: false)
                          .atualizarCliente(cliente);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Por favor, preencha todos os campos corretamente.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFormFields(
      Map<String, TextEditingController> controllers) {
    return controllers.entries
        .where((entry) => entry.key != 'estado')
        .map((entry) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: entry.value,
          decoration: InputDecoration(labelText: entry.key),
        ),
      );
    }).toList();
  }

  Widget _buildStateDropdown(TextEditingController estadoController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Estado',
        ),
        value: estadoController.text,
        hint: Text('UF*'),
        isDense: true,
        menuMaxHeight: 300,
        onChanged: (String? newValue) {
          estadoController.text = newValue!;
        },
        items: _states.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  bool _validateFields(Map<String, TextEditingController> controllers) {
    return controllers.values.every((controller) => controller.text.isNotEmpty);
  }
}
