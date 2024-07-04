import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:provider/provider.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({Key? key}) : super(key: key);

  @override
  State<VendasPage> createState() => _VendasPageState();
}

class _VendasPageState extends State<VendasPage> {
  String contagem = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setProdutos();
    });
  }

  void setProdutos() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      contagem = productProvider.contarProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                SalesCard(
                  icon: FontAwesomeIcons.coins,
                  iconColor: Colors.blue,
                  title: 'Total de Vendas Hoje',
                  value: '8', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.coins,
                  iconColor: Colors.green,
                  title: 'Vendas Aprovadas',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.coins,
                  iconColor: Colors.red,
                  title: 'Vendas Pendentes',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.dollarSign,
                  iconColor: Colors.green,
                  title: 'Total Vendido no Dia',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.box,
                  iconColor: Colors.green,
                  title: 'Pedidos Enviados',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.boxesStacked,
                  iconColor: Colors.red,
                  title: 'Pedidos Pendentes',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.clipboardList,
                  iconColor: Colors.blue,
                  title: 'Vendas no Mês',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.creditCard,
                  iconColor: Colors.green,
                  title: 'Total R\$ por Mês',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.users,
                  iconColor: Colors.blue,
                  title: 'Clientes Cadastrados',
                  value: '0', // Valor estático para exemplo
                ),
                
                SalesCard(
                  icon: FontAwesomeIcons.boxesStacked,
                  iconColor: Colors.blueAccent,
                  title: 'Produtos Cadastrados',
                  value: productProvider.lengthList,
                ),
                SalesCard(
                  icon: FontAwesomeIcons.clipboardCheck,
                  iconColor: Colors.grey,
                  title: 'Combos Cadastrados',
                  value: '0', // Valor estático para exemplo
                ),
                SalesCard(
                  icon: FontAwesomeIcons.boxesStacked,
                  iconColor: Colors.amber,
                  title: 'Produtos em Promoção',
                  value: '0', // Valor estático para exemplo
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SalesCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const SalesCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white.withOpacity(0.5),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    children: [
                      FaIcon(
                        icon,
                        color: iconColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(color: iconColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
