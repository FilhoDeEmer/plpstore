import 'package:url_launcher/url_launcher.dart';

class FuncaoExterna {
  final urlInsta = 'https://www.instagram.com/plpstore_/';
  final urlWhats = 'https://api.whatsapp.com/send?phone=5513996187797&text=Olá'; // Exemplo para WhatsApp
  final urlMail = 'mailto:example@example.com'; // Exemplo para email

  void instagram() async {
    await _launchURL(Uri.parse(urlInsta));
  }

  void whatsApp() async {
    await _launchURL(Uri.parse(urlWhats));
  }

  void email() async {
    await _launchURL(Uri.parse(urlMail));
  }

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível acessar $url';
    }
  }
}
