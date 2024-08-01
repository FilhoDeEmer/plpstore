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
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context)
                .popAndPushNamed(AppRoutes.home, arguments: {'index' : 1});
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
        backgroundColor: Color.fromRGBO(212, 175, 55, 1),
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
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
      case 1:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
      case 2:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
      case 3:
        Navigator.of(context)
            .popAndPushNamed(AppRoutes.home, arguments: {'index': index});
        break;
    }
  }
}
