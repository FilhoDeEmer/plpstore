import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/gerar_pedido.dart';
import 'package:plpstore/utils/app_routes.dart';

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
      } else {
        pedidos = [...pedidos, ...nextItems];
      }
      _isLoading = false;
    });
  }

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
            : ListView.builder(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ID: ${pedido['id'].toString()}'),
                              Row(
                                children: [
                                  Text(
                                    'Status:',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Tooltip(
                                    message: pedido['pago'] == 'Não'
                                        ? 'Aguardando pagamento'
                                        : 'Status: ${pedido['status']}',
                                    child: FaIcon(
                                      _getIconForStatus(pedido['status']).icon,
                                      color: _getIconForStatus(pedido['status'])
                                          .color,
                                      size: _getIconForStatus(pedido['status'])
                                          .size,
                                    ),
                                  ),
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
                                Text('Cod. Rastreio: ${pedido['rastreio']}'),
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
                                  // Implementar ação para visualizar o pedido
                                },
                                child: Text('Ver pedido'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (pedido['pago'] == 'Não')
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    pagarPedido(
                                        pedido['id'].toString(),
                                        pedido['id_usuario'].toString(),
                                        double.parse(pedido['total']));
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
    );
  }

  FaIcon _getIconForStatus(String status) {
    switch (status) {
      case 'Retirada':
        return FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          color: Colors.green,
          size: 12,
        );
      case 'Entregue':
        return FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          color: Colors.green,
          size: 12,
        );
      case 'Não enviado':
        return FaIcon(
          FontAwesomeIcons.hourglassHalf,
          color: Colors.orange,
          size: 12,
        );
      case 'Cancelado':
        return FaIcon(
          FontAwesomeIcons.solidCircleXmark,
          color: Colors.red,
          size: 12,
        );
      case 'Disponivel':
        return FaIcon(
          FontAwesomeIcons.mapPin,
          color: Colors.red,
          size: 12,
        );
      case '':
        return FaIcon(
          FontAwesomeIcons.dollarSign,
          color: Colors.red,
          size: 12,
        );
      default:
        return FaIcon(
          FontAwesomeIcons.circleExclamation,
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
      await _launchInWebViewWithoutDomStorage(urlPayment['test_init_point']!);
    }
  }

  Future<void> _launchInWebViewWithoutDomStorage(String url) async {
    Navigator.of(context).popAndPushNamed(AppRoutes.checkout, arguments: url);
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
