import 'dart:convert';
import 'package:http/http.dart' as http;

class CalculadoraFrete {
  Future<double> calcularFrete(
      String cep, String valor, String tipoFrete) async {
    if (tipoFrete == 'Retirar no Local') {
      return 0.0;
    } else {
      const url = 'https://www.melhorenvio.com.br/api/v2/me/shipment/calculate';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ',
        'User-Agent': 'email',
        'Accept': 'application/json'
      };

      final body = jsonEncode({
        "from": {"postal_code": "08752-580"},
        "to": {"postal_code": cep},
        "package": {"height": 10, "width": 13, "length": 17, "weight": 0.300},
        "options": {
          "insurance_value": valor,
          "receipt": false,
          "own_hand": false
        }
      });

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body) as List<dynamic>;

          final frete = responseData.firstWhere(
              (service) =>
                  service is Map<String, dynamic> &&
                  service['name'] == tipoFrete,
              orElse: () => null);

          if (frete != null && frete is Map<String, dynamic>) {

            if (frete.containsKey('price') && frete['price'] is String) {
              try {
                return double.parse(frete['price'].toString()) + 5.00;
              } catch (e) {
                return 22.0; // Valor padrão ou tratamento adequado em caso de erro
              }
            } else {
              return 22.0; // Valor padrão ou tratamento adequado
            }
          } else {
            return 22.0; // Valor padrão ou tratamento adequado
          }
        } else {
          return 22.0;
        }
      } catch (e) {
        return 22.0;
      }
    }
  }
}
