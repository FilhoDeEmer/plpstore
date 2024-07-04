import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GerarPedido with ChangeNotifier {
  Future<void> gerarPedido(String pedido) async {
    const url = 'https://plpstore.com.br/apis/api/carrinho/inserir.php';
    final response = await http.post(Uri.parse(url), body: pedido);
    final responseData = jsonDecode(response.body); 
    print(responseData);
  }
}