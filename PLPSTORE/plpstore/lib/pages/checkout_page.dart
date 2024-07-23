import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyAppTest extends StatelessWidget {
  final String? url;

  const MyAppTest({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifique se a URL é nula ou vazia
    final String initialUrl = url ?? 'https://example.com'; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
