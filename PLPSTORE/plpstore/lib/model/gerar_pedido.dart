import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GerarPedido with ChangeNotifier {
  Future<String> gerarPedido(String pedido) async {
    const url = 'https://plpstore.com.br/apis/api/carrinho/inserir.php';
    final response = await http.post(Uri.parse(url), body: pedido);
    final responseData = jsonDecode(response.body);
    if (responseData['code'] == 1) {
      final RegExp regex = RegExp(r'ID da venda: (\d+)');
      final Match? match = regex.firstMatch(responseData['message']);
      if (match != null) {
        return match.group(1)!;
      }
      return 'ID não encontrado';
    } else {
      print(responseData);
      return 'fail';
    }
  }

  var accessToken =
      "APP_USR-6558376728906994-041714-06373b57e10b878abe198ed0914acf09-1728049498";

  Future<Map<String, String>> criarPreferencia(double price) async {
    const String url = 'https://api.mercadopago.com/checkout/preferences';

    final Map<String, dynamic> body = {
      "items": [
        {
          "id": "1234",
          "title": "Cartas da PLP Store",
          "category_id": "jogo_de_cartas",
          "quantity": 1,
          "picture_url": 'https://plpstore.com.br/img/logo.png',
          "currency_id": "BRL",
          "unit_price": price,
        },
      ],
      "back_urls": {
        "success": ""
    },
      "statement_descriptor": "Plp Store",
      "auto_return": "all",
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      String id_payment = responseData['id'];
      String initPoint = responseData['init_point'];
      print(id_payment);
      return {
        'id_payment': id_payment,
        'init_point': initPoint,
      };
    } else {
      return {
        'id_payment': 'fail',
        'init_point': 'Falha ao criar preferência',
      };
    }
  }

  Future<void> verificarpagamento(String id) async {
    String url = 'https://api.mercadopago.com/v1/payments/$id';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print(responseData);


    } else {
      print('falha');
    }
  }
}
