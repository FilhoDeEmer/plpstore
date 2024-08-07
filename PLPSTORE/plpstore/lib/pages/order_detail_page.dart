import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<dynamic> pedidos = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10; // Número de itens por página
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pedidos = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
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
    if (!_hasMore || _isLoading) return; // Evita múltiplas chamadas simultâneas

    setState(() {
      _isLoading = true;
    });

    // Simula uma chamada de API para carregar mais dados
    await Future.delayed(const Duration(seconds: 2));

    final nextItems = pedidos
        .skip(_currentPage * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    setState(() {
      _currentPage++;
      if (nextItems.isEmpty) {
        _hasMore = false;
      } else {
        pedidos.addAll(nextItems);
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
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.8, // Ajuste conforme necessário
          ),
          itemCount: pedidos.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= pedidos.length) {
              _loadData(); // Carregar mais dados quando o usuário rolar até o final
              return Center(child: CircularProgressIndicator());
            }

            final pedido = pedidos[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(formatarData(pedido['data'].toString())),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ${pedido['total']}'),
                    Text('Pago: ${pedido['pago']}'),
                    Text('Estado: ${pedido['estado']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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
