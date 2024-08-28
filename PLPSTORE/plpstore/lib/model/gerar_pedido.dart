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
      return 'fail';
    }
  }

  Future<Map<String, String>> criarPreferencia(
      double price, String id_user, String id_venda) async {
    String idProduct = id_user + id_venda;
    const String url = 'https://plpstore.com.br/apiEmerson/preference.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': idProduct,
          'unit_price': price,
          'id_user': id_user,
          'id_venda': id_venda
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String id_payment = responseData['response']['id'];
        String initPoint = responseData['response']['init_point'];
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
      return {
        'id_payment': 'fail',
        'init_point': 'Falha ao criar preferência',
      };
    }
  }

  Future<List<Map<String, dynamic>>> detalhesPedido(
      String pedido, String idUsuario) async {
    String url =
        'https://plpstore.com.br/apis/api/vendas/vendasClientesProdutos.php?idUsuario=$idUsuario&idVenda=$pedido';

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = jsonDecode(response.body);

      if (responseData['code'] == 1) {
        return List<Map<String, dynamic>>.from(responseData['result']);
      } else {
        throw Exception('Falha ao buscar detalhes do pedido.');
      }
    } catch (e) {
      throw Exception('Erro ao processar a solicitação: $e');
    }
  }

  // Future<void> verificarpagamento(String id) async {
  //   String url = 'https://api.mercadopago.com/v1/payments/$id';

  //   final response = await http.post(
  //     Uri.parse(url),
  //   );
  //   if (response.statusCode == 201) {
  //     final responseData = jsonDecode(response.body);
  //   } else {
  //   }
  // }
}
