import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/app_drawer.dart';
import 'package:plpstore/components/badgee.dart';
import 'package:plpstore/components/bottom_navigator.dart';
import 'package:plpstore/components/home_page_components.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/components/category_page.dart';
import 'package:plpstore/model/get_clientes.dart';
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

  final List<Widget> _pages = [
    const PrincipalPage(),
    const CategoryPage(),
    const Center(
      child: Text('Produtos'),
    ),
    const Center(
      child: Text('Promoção'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = widget.index ?? 0;
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('index')) {
      setState(() {
        index = args['index'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context);
    String user = token.getToken();
    final cart = Provider.of<Cart>(context);
    final cliente = Provider.of<GetCliente>(context);

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
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child:
                    user.isEmpty ? const Text('Entrar') : const Text('Perfil'),
                onTap: () => user.isEmpty
                    ? Navigator.of(context).pushNamed(AppRoutes.login)
                    : Navigator.of(context).pushNamed(AppRoutes.perfil),
              ),
              PopupMenuItem(
                child: const Text('Meus Pedidos'),
                onTap: () => user.isEmpty
                    ? Navigator.of(context).pushNamed(AppRoutes.login)
                    : Navigator.of(context).pushNamed(
                        AppRoutes.perfil), // mudar para pedidos quando tiber
              ),
              if (user.isNotEmpty)
                PopupMenuItem(
                  child: const Text('Sair'),
                  onTap: () {                    
                    cart.clean();
                    cliente.sair();
                    token.logout();
                  },
                ),
            ],
          ),
        ],
      ),
      body: _pages[index],
      drawer: AppDrawer(
        onOptionSelected: (String option) {},
      ),
      bottomNavigationBar: BottonNavigator(
          currentIndex: index,
          onTap: (int i) {
            setState(() {
              index = i;
            });
          }),
      // backgroundColor: Colors.white,
    );
  }
}
