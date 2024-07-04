import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:plpstore/components/badgee.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double price = 10.00;
  String? preferenceId;
  Future<void> criarPreferenciaDePagamento() async {
    const accessToken =
        'APP_USR-6558376728906994-041714-06373b57e10b878abe198ed0914acf09-1728049498';
    final url = Uri.parse('https://api.mercadopago.com/checkout/preferences');

    Map<String, dynamic> body = {
      "items": [
        {
          "title": "Pedido número : #15215",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": price
        }
      ],
      "back_urls": {
        "success": "myapp://payment-success",
        "failure": "myapp://payment-failure",
        "pending": "myapp://payment-pending",
      },
      "auto_return": "approved"
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(response.body);
      if (response.statusCode == 201) {
        preferenceId = jsonDecode(response.body)['id'];
        print('Preferência de pagamento criada com sucesso: $preferenceId');
        _launchURL(context, preferenceId);
        // Aqui você pode prosseguir com o processamento da preferência
      } else {
        print('Erro ao criar preferência de pagamento: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Erro na requisição HTTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
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
            builder: (context, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.cart);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            criarPreferenciaDePagamento();
          },
          child: const Text('Pagar com Mercado Pago'),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String? preferenceId) async {
    try {
      await launchUrl(
        Uri.parse(
            'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=$preferenceId'),
        prefersDeepLink: true,
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: Colors.blue,
          ),
          animations: const CustomTabsAnimations(
            startEnter: 'slide_up',
            startExit: 'android:anim/fade_out',
            endEnter: 'android:anim/fade_in',
            endExit: 'slide_down',
          ),
          shareState: CustomTabsShareState.off,
          urlBarHidingEnabled: true,
          instantAppsEnabled: false,
          showTitle: false,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
