import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class FuncaoExterna {
  final String urlInsta = 'https://www.instagram.com/plpstore_';
  final String urlWhats =
      'https://api.whatsapp.com/send?phone=5513996187797&text=Olá';
  final String urlMail = 'mailto:adm@plpstore.com.br';
  final String urlSite = 'https://www.plpstore.com.br';

  void instagram() async {
    await _launchURL(urlInsta);
  }

  void whatsApp() async {
    await _launchURL(urlWhats);
  }

  void email() async {
    await _launchURL(urlMail);
  }
  void site() async {
    await _launchURL(urlSite);
  }

  Future<void> _launchURL(String urlString) async {
    try {
      await launchUrl(
        Uri.parse(urlString),
      );
    } catch (e) {
      throw 'Não foi possível acessar $urlString';
    }
  }
}
