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
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjM1ZTVhNjUzYjJjZDQ2MWVhNjdlMWFkMTA3ZjVmMTQyNDY1ZGI1YTk4ZWE4YzMxMWJiOWM3OTBiMWVjNDVhMTZiMGEzNTg0MWU2ODhlOWIiLCJpYXQiOjE3MjMwNTc4OTMuMzQ3NDYyLCJuYmYiOjE3MjMwNTc4OTMuMzQ3NDYzLCJleHAiOjE3NTQ1OTM4OTMuMzM0NzEyLCJzdWIiOiI5Y2I2MTA3ZC1iNDcwLTQzZTktYjNjOS0zYWQ1ODMwYjYzODgiLCJzY29wZXMiOlsic2hpcHBpbmctY2FsY3VsYXRlIl19.PLo53OBbU4D_BR1lf_-wYjbxVcvWKV5Q9Ir5nao5XQ1grNrclSpeD-eDesBx76wNEC_lvccJS8pfgxL0k3VaMdN1QOQV5ud_1BHtTky-pPGwTKIBOeASYd4KUojqxJEo0Ko1CAAgnYEL8Keks_hvnuCCv1_dm1dYSlx1LB0_d57KAEDadACz1421xKE2GmNStmAMuwEpnFrnqz7esrRHMWbGWmrXDOiQkzAHGvMp-Xp-zgX3Pu-8PfwrcZrxT6L_U9HA-6FQJfSRVsEWrg5E2NAtX3WJGycjkFs4aBH8Ra2BGY2VxfXD7E-C_ihKADuIYVv-uOABcKPblTTcEa2z3rxaQTDVKEX2Ox5TnPlPmEdXitNXLFzxS4_ZT4uogF2Ad75uUAYevkJym7MLZ_9jNbHidmMdRr7CxvqsnKHfi_GV1ClkXlRapOk1-9zvK8kvhBW1gUONhC2EYvSEAoouRq41P_VuenvrRTfnz2ryRjFcQLZ_ecKgBgIt6MoCOPgmbTwnH65ENzEJwPSxAnCpidqjyEE1k_t5uzyj1v5LzEAHuKR9darvGhDb4g8D7rgl9SguThw4OD5O956-Yf5JYe6usM-r_QOk55lFblyJGvZqxkREnjQJ-r1skJv-_K4Ew6Dv9aZQXKa0anKNqB3rht7ibd-WyXL66AWQKWPTxvk',
        'User-Agent': 'filhodeemer@gmail.com',
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
            // Verifica se o campo 'price' existe no mapa e se é um valor válido
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
