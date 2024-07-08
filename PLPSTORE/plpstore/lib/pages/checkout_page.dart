import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:plpstore/components/badgee.dart';
import 'package:plpstore/model/cart.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    const id = '156318921315';
    const price = '1.00';
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
            _launchURL(context, id, price);
            Navigator.of(context).popAndPushNamed(AppRoutes.perfil);
          },
          child: const Text('Pagar com Mercado Pago'),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String id, String price) async {
    try {
      await launchUrl(
        Uri.parse(
            'http://192.168.1.8:3000/create-preference?id=$id&price=$price'),
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
