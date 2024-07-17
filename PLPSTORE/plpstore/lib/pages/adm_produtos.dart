import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/pages/colecao_edit_page.dart';
import 'package:plpstore/utils/app_routes.dart';

class ProdutosAdmPage extends StatefulWidget {
  const ProdutosAdmPage({super.key});

  @override
  State<ProdutosAdmPage> createState() => _ProdutosAdmPageState();
}

class _ProdutosAdmPageState extends State<ProdutosAdmPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Cadastro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: Divider(
              color: Colors.blue,
              height: 1,
              thickness: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              leading: const FaIcon(FontAwesomeIcons.box),
              title: const Text('Produtos'),
              children: [
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.hardDrive),
                  title: const Text('Itens'),
                  onTap: () {Navigator.of(context).pushNamed(AppRoutes.editProduct);},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.windowRestore),
                  title: const Text('Coleções'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ColecaoEditPage()));
                    },
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.list),
                  title: const Text('Sub Categorias'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.truckFast),
                  title: const Text('Tipo de Envios'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.diagramProject),
                  title: const Text('Características'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              leading: const FaIcon(FontAwesomeIcons.cube),
              title: const Text('Combos e Promoções'),
              children: [
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.cube),
                  title: const Text('Combos'),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.combos);
                  },
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.dollarSign),
                  title: const Text('Promoções'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.triangleExclamation),
                  title: const Text('Alertas'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.images),
                  title: const Text('Banner Principal'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Consulta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: Divider(
              color: Colors.blue,
              height: 1,
              thickness: 3,
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.tags),
                title: const Text('Cupons'),
                onTap: () {},
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.user),
                title: const Text('Clientes'),
                onTap: () {},
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.piggyBank),
                title: const Text('Vendas'),
                onTap: () {},
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.storeSlash),
                title: const Text('Estoque Baixo'),
                onTap: () {},
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Outros',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.envelopeOpenText),
            title: const Text('E-mail de Marketing'),
            onTap: () {},
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.receipt),
            title: const Text('Relatório de Vendas'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
