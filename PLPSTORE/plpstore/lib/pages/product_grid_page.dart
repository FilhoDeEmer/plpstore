import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/bottom_navigator.dart';
import 'package:plpstore/components/product_grid.dart';
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

    final cart = Provider.of<Cart>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: 1);
          },
        ),
        title: FittedBox(
          child: Text(
            page,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
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
        centerTitle: true,
      ),
      body: ProductGrid(
        colecao: page != 'Buscar' ? page : paramns,
      ),
      bottomNavigationBar: BottomNavigator(
        currentIndex: index,
        onTap: (int i) {
          setState(() {
            index = i;
          });
          _navigateToPage(i, context);
        },
        cartItemCount: cart.itemsCount,
      ),
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: index);
        break;
      case 1:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: index);
        break;
      case 2:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: index);
        break;
      case 3:
        Navigator.of(context).popAndPushNamed(AppRoutes.home, arguments: index);
        break;
    }
  }
}
