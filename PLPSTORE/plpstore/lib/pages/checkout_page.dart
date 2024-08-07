import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyAppTest extends StatelessWidget {
  final String? url;

  const MyAppTest({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifique se a URL é nula ou vazia
    final String initialUrl =
        ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.of(context)
                    .popAndPushNamed(AppRoutes.home, arguments: 3);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text(
          'Pagamento',
          style: TextStyle(
            color: Color.fromARGB(255, 153, 143, 0),
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 153, 143, 0)),
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
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
