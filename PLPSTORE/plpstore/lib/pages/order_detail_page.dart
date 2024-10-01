import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/gerar_pedido.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<dynamic> pedidos = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List<dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    if (args != null) {
      pedidos = args;
      pedidos.sort((a, b) => b['id'].compareTo(a['id']));
    }
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadData() async {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final nextItems =
        pedidos.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();
    setState(() {
      _currentPage++;
      if (nextItems.isEmpty) {
        _hasMore = false;
      }
      // Adiciona mais itens, se houver
      pedidos = [...pedidos];
      _isLoading = false;
    });
  }

  final GerarPedido buscarPedido = GerarPedido();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedidos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? Center(child: PokeballLoading())
            : Column(
                children: [
                  Text(
                    '*Pagamentos via PIX podem demorar para ser processados, caso já tenha feito o pagamento mas ainda não foi alterado entre em contato',
                    style: TextStyle(fontSize: 10),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pedidos.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= pedidos.length) {
                          _loadData();
                          return Center(child: PokeballLoading());
                        }

                        final pedido = pedidos[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ID: ${pedido['id'].toString()}'),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Status:',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            FaIcon(
                                              _getIconForStatus(pedido).icon,
                                              color: _getIconForStatus(pedido)
                                                  .color,
                                              size: _getIconForStatus(pedido)
                                                  .size,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          _getIconForStatus(pedido)
                                              .semanticLabel!,
                                          style: TextStyle(fontSize: 8),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total: ${pedido['total']}'),
                                    Text('Pago: ${pedido['pago']}'),
                                    if (pedido['rastreio'] != null)
                                      Text(
                                          'Cod. Rastreio: ${pedido['rastreio']}'),
                                    Text(
                                        'Data: ${formatarData(pedido['data'].toString())}'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        verPedido(
                                          context,
                                          pedido['id'].toString(),
                                          pedido['id_usuario'].toString(),
                                          pedido['total'],
                                        );
                                      },
                                      child: Text('Ver pedido'),
                                    ),
                                    SizedBox(width: 10),
                                    if (pedido['pago'] == 'Não')
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await pagarPedido(
                                            pedido['id'].toString(),
                                            pedido['id_usuario'].toString(),
                                            double.parse(pedido['total']),
                                          );
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                        child: Text('Pagar'),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> verPedido(BuildContext context, String pedidoId,
      String idUsuario, String totalPedido) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: FittedBox(child: Text('Detalhes do Pedido: $pedidoId')),
          content: FutureBuilder<List<Map<String, dynamic>>>(
            future: buscarPedido.detalhesPedido(pedidoId, idUsuario),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: PokeballLoading());
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                    'Nenhum detalhe encontrado para este pedido.');
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Produto: ${item['nome_produto']}'),
                            Text('Quantidade: ${item['quantidade']}'),
                            const SizedBox(height: 10),
                            const Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: $totalPedido'),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
//verificar os status reais de pedidos
  FaIcon _getIconForStatus(dynamic status) {
    switch (status['status']) {
      case 'Retirada':
        return FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          semanticLabel: 'Entregue',
          color: Colors.green,
          size: 12,
        );
      case 'Entregue':
        return FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          semanticLabel: 'Entregue',
          color: Colors.green,
          size: 12,
        );
      case 'Não enviado':
        return FaIcon(
          FontAwesomeIcons.hourglassHalf,
          semanticLabel: 'Aguardando envio',
          color: Colors.orange,
          size: 12,
        );
      case 'Cancelado':
        return FaIcon(
          FontAwesomeIcons.solidCircleXmark,
          semanticLabel: 'Cancelada',
          color: Colors.red,
          size: 12,
        );
      case 'Disponivel':
        return FaIcon(
          FontAwesomeIcons.mapPin,
          semanticLabel: 'Aguardando retirada',
          color: Colors.red,
          size: 12,
        );
      case '':
        return FaIcon(
          FontAwesomeIcons.dollarSign,
          color: Colors.red,
          semanticLabel: 'Aguardando pagamento',
          size: 12,
        );
      default:
        return FaIcon(
          FontAwesomeIcons.circleExclamation,
          semanticLabel: 'Aguardando',
          color: Colors.grey,
          size: 14,
        );
    }
  }

  Future<void> pagarPedido(
      String idPedido, String idUsuario, double valorTotal) async {
    final gerarPedido = GerarPedido();
    final urlPayment =
        await gerarPedido.criarPreferencia(valorTotal, idUsuario, idPedido);
    if (urlPayment['id_payment'] != 'fail') {
      await _launchInWebViewWithoutDomStorage(urlPayment['init_point']!);
    }
  }

  Future<void> _launchInWebViewWithoutDomStorage(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
      );
    } catch (e) {
      throw 'Não foi possível acessar $url';
    }
  }

  String formatarData(String data) {
    try {
      DateTime dateTime = DateTime.parse(data);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'Data inválida';
    }
  }
}
