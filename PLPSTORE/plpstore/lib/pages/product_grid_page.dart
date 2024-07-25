import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/badgee.dart';
import 'package:plpstore/components/bottom_navigator.dart';
import 'package:plpstore/components/product_grid.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductGridPage extends StatefulWidget {
  final String? colectionName;
  const ProductGridPage({required this.colectionName, super.key});

  @override
  State<ProductGridPage> createState() => _ProductGridPageState();
}

class _ProductGridPageState extends State<ProductGridPage> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    String? paramns = ModalRoute.of(context)?.settings.arguments as String?;
    List<String> list = paramns!.split(',');
    String page = list[0];
    
    

    final token = Provider.of<Auth>(context);
    String user = token.getToken();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: FittedBox(
          child: Text(
            page,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
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
          if (user.isEmpty)
           IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.login);
              },
              icon: const FaIcon(FontAwesomeIcons.solidCircleUser),
            ),
          
          if (user.isNotEmpty)
          PopupMenuButton(
            icon: const FaIcon(FontAwesomeIcons.solidCircleUser),
            itemBuilder: (_) => [
              PopupMenuItem(
                child:
                    user.isEmpty ? const Text('Entrar') : const Text('Perfil'),
                onTap: () => user.isEmpty
                    ? Navigator.of(context).pushNamed(AppRoutes.login)
                    : Navigator.of(context).pushNamed(AppRoutes.perfil),
              ),
              const PopupMenuItem(child: Text('Meus Pedidos')),
              if (user.isNotEmpty)
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
        colecao: page != 'Buscar' ? page : paramns,
      ),
      bottomNavigationBar: BottonNavigator(currentIndex: index, 
        onTap: (int i) {
          setState(() {
            index = i;
          });
          _navigateToPage(i, context);
        },
      ),
    );
  }
  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: {'index' : index});
        break;
      case 1:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: {'index' : index});
        break;
      case 2:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: {'index' : index});
        break;
      case 3:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: {'index' : index});
        break;
    }
  }
}
