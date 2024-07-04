import 'package:flutter/material.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/pages/cart_page.dart';
import 'package:plpstore/pages/home_page.dart';
import 'package:plpstore/pages/login_page.dart';
import 'package:plpstore/pages/perfil.dart';
import 'package:plpstore/pages/product_grid_page.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'PLP Store',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(33, 150, 243, 1)),
          useMaterial3: true,
        ),
        routes: {
          AppRoutes.login: (ctx) => const LoginPage(),
          AppRoutes.home: (ctx) => const HomePage(),
          AppRoutes.cart: (ctx) => const CartPage(),
          AppRoutes.perfil: (ctx) => const PerfilPage(),
          AppRoutes.colection: (ctx) => const ProductGridPage(allProducts: {}, colecaoSigla: '', colectionName: '', idColection: '',),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
