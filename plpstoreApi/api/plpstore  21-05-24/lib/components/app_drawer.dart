import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/model/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final Function(String) onOptionSelected;
  const AppDrawer({Key? key, required this.onOptionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    String nome = user.getName();
    List<String> palavras = nome.split(' ');
    nome = palavras.isNotEmpty ? palavras[0] : '';
    
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Bem Vindo $nome!',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.house),
            title: const Text('Home'),
            onTap: () {
              onOptionSelected('Home');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ExpansionTile(
            title: const Text('Coleções'),
            leading: const FaIcon(FontAwesomeIcons.bagShopping),
            children: [              
              ListTile(
                title: const Text('Mascaras do Crepúsculo'),
                onTap: () {
                  onOptionSelected('Mascaras do Crepúsculo');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Forças Temporais'),
                onTap: () {
                  onOptionSelected('Forças Temporais');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Destinos de paldea'),
                onTap: () {
                  onOptionSelected('Destinos de paldea');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Fenda Paradoxal'),
                onTap: () {
                  onOptionSelected('Fenda Paradoxal');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Escarlate e Violeta 151'),
                onTap: () {
                  onOptionSelected('Escarlate e Violeta 151');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.store),
            title: const Text('Produtos'),
            onTap: () {
              onOptionSelected('Produtos');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ExpansionTile(
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
                onTap: () {},
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.whatsapp),
                title: const Text('(13) 99618-7797'),
                onTap: () {},
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
            iconColor: Colors.red,
            onTap: () {},
          )
        ],
      ),
    );
  }
}
