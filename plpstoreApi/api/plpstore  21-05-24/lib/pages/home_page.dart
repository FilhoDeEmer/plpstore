import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/app_drawer.dart';
import 'package:plpstore/components/badgee.dart';
import 'package:plpstore/components/home_page_components.dart';
import 'package:plpstore/components/product_grid.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String page = 'Home';
  late Future<Map<String, dynamic>> _allProductsFuture;

  @override
  void initState() {
    super.initState();
    _allProductsFuture = getAllProduct();
  }

  Future<Map<String, dynamic>> getAllProduct() async {
    return await Produtos().allProducts();
  }

  Widget _buildPageContent(Map<String, dynamic> allProducts) {
    switch (page) {
      case 'Home':
        return const PrincipalPage();
      case 'Mascaras do Crepúsculo':
        return ProductGrid(
          colection: allProducts['Mascaras do Crepúsculo'],
          colecao: 'twilight-masquerade',
          idColection: 'SV06',
        );
      case 'Forças Temporais':
        return ProductGrid(
          colection: allProducts['Forças Temporais'],
          colecao: 'temporal-forces',
          idColection: 'SV05',
        );
      case 'Destinos de paldea':
        return ProductGrid(
          colection: allProducts['Destinos de Paldea'],
          colecao: 'paldean-fates',
          idColection: 'SV4pt5',
        );
      case 'Fenda Paradoxal':
        return ProductGrid(
          colection: allProducts['Fenda Paradoxal'],
          colecao: 'paradox-rift',
          idColection: 'SV04',
        );
      case 'Escarlate e Violeta 151':
        return ProductGrid(
          colection: allProducts['Escarlate e Violeta 151'],
          colecao: '151',
          idColection: 'SV3pt5',
        );
      case 'Produtos':
        return const Center(
          child: Text('Produtos'),
        );
      default:
        return const Center(
          child: Text('Página não encontrada'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context);
    String user = token.getToken();

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
          'PLP Store',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const FaIcon(FontAwesomeIcons.cartShopping),
            ),
            builder: (context, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
          PopupMenuButton(
            icon: const FaIcon(FontAwesomeIcons.solidCircleUser),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: user.isEmpty ? const Text('Entrar') : const Text('Perfil'),
                onTap: () => user.isEmpty
                    ? Navigator.of(context).pushNamed(AppRoutes.login)
                    : Navigator.of(context).pushNamed(AppRoutes.perfil),
              ),
              const PopupMenuItem(child: Text('Meus Pedidos')),
              PopupMenuItem(
                child: const Text('Sair'),
                onTap: () {
                  token.logout();
                },
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _allProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar produtos'));
          } else if (snapshot.hasData) {
            final allProducts = snapshot.data!;
            return _buildPageContent(allProducts);
          } else {
            return const Center(child: Text('Nenhum dado disponível'));
          }
        },
      ),
      drawer: AppDrawer(
        onOptionSelected: (String option) {
          setState(() {
            page = option;
          });
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
