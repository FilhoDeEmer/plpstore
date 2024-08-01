import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/funcao_externas.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final Function(String) onOptionSelected;
  const AppDrawer({Key? key, required this.onOptionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    String nome = user.getName();
    String level = user.getLevel();
    List<String> palavras = nome.split(' ');
    nome = palavras.isNotEmpty ? palavras[0] : '';
    final cart = Provider.of<Cart>(context);
    final cliente = Provider.of<GetCliente>(context);

    return Drawer(
      backgroundColor: Color.fromARGB(255, 217, 232, 255),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Bem Vindo !',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromRGBO(37, 60, 78, 1),
            ),
            Container(
              height: 150,
              width: 150,
              child: Image.asset('assets/img/logo_plp.png'),
            ),
            Text('Nome'),
            Card(
              elevation: 8,
              color: Color.fromARGB(255, 217, 232, 255),
              child: ListTile(
                leading: const FaIcon(FontAwesomeIcons.user),
                title: const Text('Entrar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).popAndPushNamed(AppRoutes.home);
                },
              ),
            ),
            Card(
              elevation: 8,
              color: Color.fromARGB(255, 217, 232, 255),
              child: ListTile(
                leading: const FaIcon(FontAwesomeIcons.house),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).popAndPushNamed(AppRoutes.home);
                },
              ),
            ),
            Card(
              elevation: 8,
              color: Color.fromARGB(255, 217, 232, 255),
              child: ExpansionTile(
                title: const Text('Coleções'),
                leading: const FaIcon(FontAwesomeIcons.bagShopping),
                children: [
                  ListTile(
                    title: const Text('Mascaras do Crepúsculo'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRoutes.colection,
                          arguments: 'Mascaras do Crepúsculo');
                    },
                  ),
                  ListTile(
                    title: const Text('Forças Temporais'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRoutes.colection,
                          arguments: 'Forças Temporais');
                    },
                  ),
                  ListTile(
                    title: const Text('Destinos de Paldea'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRoutes.colection,
                          arguments: 'Destinos de Paldea');
                    },
                  ),
                  ListTile(
                    title: const Text('Fenda Paradoxal'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRoutes.colection,
                          arguments: 'Fenda Paradoxal');
                    },
                  ),
                  ListTile(
                    title: const Text('Escarlate e Violeta 151'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRoutes.colection,
                          arguments: 'Escarlate e Violeta 151');
                    },
                  ),
                ],
              ),
            ),
            Card(
              elevation: 8,
              color: Color.fromARGB(255, 217, 232, 255),
              child: ListTile(
                leading: const FaIcon(FontAwesomeIcons.store),
                title: const Text('Produtos'),
                onTap: () {
                  onOptionSelected('Produtos');
                  Navigator.pop(context);
                },
              ),
            ),
            if (level == 'Admin')
              Card(
                elevation: 8,
                color: Color.fromARGB(255, 217, 232, 255),
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.gear),
                  title: const Text('Gerenciar'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).popAndPushNamed(AppRoutes.admHome);
                  },
                ),
              ),
            Card(
              elevation: 8,
              color: Color.fromARGB(255, 217, 232, 255),
              child: ExpansionTile(
                title: const Text('Contatos'),
                leading: const FaIcon(FontAwesomeIcons.addressCard),
                children: [
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.solidEnvelope),
                    title: const Text('adm@plpstore.com.br'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.instagram),
                    title: const Text('@plpstore_'),
                    onTap: () {
                      FuncaoExterna().instagram();
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.whatsapp),
                    title: const Text('(13) 99618-7797'),
                    onTap: () {
                      FuncaoExterna().whatsApp();
                    },
                  ),
                ],
              ),
            ),
            Card(
              elevation: 8,
              color: Color.fromARGB(255, 217, 232, 255),
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
                  cliente.sair();
                  Navigator.pop(context);
                  Navigator.of(context).popAndPushNamed(AppRoutes.home);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
