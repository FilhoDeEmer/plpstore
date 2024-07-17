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

  Future<Map<String, String>> criarPreferencia(double price) async {
    const String url = 'http://192.168.1.3/teste_php/preference.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': '123456',
          'unit_price': '1.00',
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String id_payment = responseData['response']['id'];
        String initPoint = responseData['response']['init_point'];
        print(initPoint);
        String testInitPoint = responseData['response']['sandbox_init_point'];
        return {
          'id_payment': id_payment,
          'init_point': initPoint,
          'test_init_point': testInitPoint,
        };
      } else {
        return {
          'id_payment': 'fail',
          'init_point': 'Falha ao criar preferência',
        };
      }
    } catch (e) {
      print('Erro ao conectar: $e');
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
    );
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print(responseData);
    } else {
      print('falha');
    }
  }

}
