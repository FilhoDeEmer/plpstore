import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/bottom_navigator.dart';
import 'package:plpstore/components/home_page_components.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/components/category_page.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:plpstore/pages/cart_page.dart';
import 'package:plpstore/pages/perfil.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int? index;
  const HomePage({super.key, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int index;
  late Auth token;
  late Cart cart;
  late GetCliente cliente;

  @override
  void initState() {
    super.initState();
    index = widget.index ?? 0; 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token = Provider.of<Auth>(context);
    cart = Provider.of<Cart>(context);
    cliente = Provider.of<GetCliente>(context);
  }

  final TextEditingController _searchController = TextEditingController();

  void searchProduct() {
    String term = _searchController.text.trim();
    if (term.isNotEmpty) {
      String list = 'Buscar,$term';
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.colection,
        arguments: list,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, insira uma palavra para pesquisa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const PrincipalPage(),
      const CategoryPage(),
      const CartPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: searchProduct,
                    icon: const FaIcon(
                      FontAwesomeIcons.searchengin,
                      color: Colors.black,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  hintText: 'Buscar na PLP Store'),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
      body: _pages[index],
      bottomNavigationBar: BottomNavigator(
        currentIndex: index,
        onTap: (int i) {
          if (i != index) {
            setState(() {
              index = i;
            });
          }
        },
        cartItemCount: cart.itemsCount,
      ),
    );
  }
}
