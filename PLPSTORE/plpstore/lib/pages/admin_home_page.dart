import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/app_drawer.dart';
import 'package:plpstore/pages/adm_produtos.dart';
import 'package:plpstore/pages/adm_vendas.dart';

class AdmHomePage extends StatefulWidget {
  const AdmHomePage({super.key});

  @override
  State<AdmHomePage> createState() => _AdmHomePageState();
}

class _AdmHomePageState extends State<AdmHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const FaIcon(FontAwesomeIcons.bars),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text(
          'Administração',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: const DefaultTabController(
        length: 2,
        child: Column(
          children: [
             TabBar(
              tabs: [
                Tab(text: 'Infomativos'),
                Tab(text: 'Produtos'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children:  [
                  // Conteúdo para a primeira aba
                  VendasPage(),
                  // Conteúdo para a segunda aba
                  ProdutosAdmPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(onOptionSelected: (_) {}),
      backgroundColor: Colors.white,
    );
  }
}
