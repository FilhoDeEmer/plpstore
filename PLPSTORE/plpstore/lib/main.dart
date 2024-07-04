import 'package:flutter/material.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/model/combo_list.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:plpstore/pages/admin_home_page.dart';
import 'package:plpstore/pages/cart_page.dart';
import 'package:plpstore/components/category_page.dart';
import 'package:plpstore/pages/checkout_page.dart';
import 'package:plpstore/pages/combo_page.dart';
import 'package:plpstore/pages/edit_product_page.dart';
import 'package:plpstore/pages/home_page.dart';
import 'package:plpstore/pages/login_page.dart';
import 'package:plpstore/pages/order_page.dart';
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
        ChangeNotifierProvider(create: (_) => ComboList()),
        ChangeNotifierProvider(create: (_) => Produtos()),
        ChangeNotifierProvider(create: (_) => GetCliente()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'PLP Store',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(33, 150, 243, 1)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.login: (ctx) => const LoginPage(),
          AppRoutes.home: (ctx, {int? page} ) =>  HomePage(index: page,),
          AppRoutes.category: (ctx) => const CategoryPage(),
          AppRoutes.admHome: (ctx) => const AdmHomePage(),
          AppRoutes.editProduct: (ctx) => const EditProductPage(),
          AppRoutes.cart: (ctx) => const CartPage(),
          AppRoutes.perfil: (ctx) => const PerfilPage(),
          AppRoutes.pedido: (ctx) => const OrderPage(),
          AppRoutes.combos: (ctx) => const ComboPage(),
          AppRoutes.checkout: (ctx) => const CheckoutPage(),
          AppRoutes.colection: (ctx, {String? colectionName}) => ProductGridPage(colectionName: colectionName),
        },
        
      ),
    );
  }
}
