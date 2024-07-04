import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/badgee.dart';
import 'package:plpstore/components/product_grid.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductGridPage extends StatefulWidget {
  final Map<String, dynamic> allProducts;
  final String colectionName;
  final String colecaoSigla;
  final String idColection;
  const ProductGridPage(
      {required this.allProducts,
      required this.colecaoSigla,
      required this.colectionName,
      required this.idColection,
      super.key});

  @override
  State<ProductGridPage> createState() => _ProductGridPageState();
}

class _ProductGridPageState extends State<ProductGridPage> {
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
                  child: user.isEmpty
                      ? const Text('Entrar')
                      : const Text('Perfil'),
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
        body: ProductGrid(
          colection: widget.allProducts[widget.colectionName],
          colecao: widget.colecaoSigla,
          idColection: widget.idColection,
        ));
  }
}
