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
import 'package:plpstore/pages/order_detail_page.dart';
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
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(165, 143, 43, 1), // Cor principal
            primary: Color.fromRGBO(255, 238, 6, 1), // Cor principal
            secondary: Color.fromARGB(255, 248, 147, 31), // Cor secundária
            background: Color.fromARGB(255, 255, 255, 255), // Cor de fundo
            surface: Color.fromARGB(255, 248, 248, 248), // Cor de superfície
            onPrimary: Colors.white, // Cor do texto sobre a cor primária
            onSecondary: Colors.black, // Cor do texto sobre a cor secundária
            onBackground: Colors.black, // Cor do texto sobre o fundo
            onSurface: Colors.black, // Cor do texto sobre a superfície
            error: Colors.redAccent,
            tertiary: Color.fromRGBO(165, 143, 43, 1), // Cor para erros
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(
              Color.fromRGBO(255, 239, 0, 1),
            ),
            fillColor: MaterialStateProperty.all(Colors.black),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromRGBO(255, 239, 0, 1),
            foregroundColor: Colors.white,
            centerTitle: true,
            toolbarHeight: 80,
            titleTextStyle: TextStyle(
              color: Color(0xFF7f6921),
            ),
            iconTheme: IconThemeData(color: Color.fromARGB(255, 248, 147, 31)),
            elevation: 4,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Color.fromRGBO(255, 239, 0, 1),
            textTheme: ButtonTextTheme.primary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(0, 0, 0, 1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(color: Color.fromARGB(255, 165, 143, 43)),
            displayMedium: TextStyle(color: Color.fromARGB(255, 165, 143, 43)),
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black54),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 248, 147, 31)),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            labelStyle: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.login: (ctx) => const LoginPage(),
          AppRoutes.home: (ctx) =>
              HomePage(index: ModalRoute.of(ctx)!.settings.arguments as int?),
          AppRoutes.category: (ctx) => const CategoryPage(),
          AppRoutes.admHome: (ctx) => const AdmHomePage(),
          AppRoutes.editProduct: (ctx) => const EditProductPage(),
          AppRoutes.cart: (ctx) => const CartPage(),
          AppRoutes.perfil: (ctx) => const PerfilPage(),
          AppRoutes.pedido: (ctx) => const OrderPage(),
          AppRoutes.combos: (ctx) => const ComboPage(),
          AppRoutes.orderDetail: (ctx) => const OrderDetailPage(),
          AppRoutes.checkout: (ctx) => const MyAppTest(),
          AppRoutes.colection: (ctx, {String? colectionName}) =>
              ProductGridPage(colectionName: colectionName),
        },
      ),
    );
  }
}

// AppRoutes.colection: (ctx, {String? colectionName}) => ProductGridPage(colectionName: colectionName),