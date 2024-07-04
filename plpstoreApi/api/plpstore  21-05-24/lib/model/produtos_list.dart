import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Produtos with ChangeNotifier {
  Future<Map<String, dynamic>> allProducts() async {
    const url = 'https://plpstore.com.br/apis/api/produtos/listarProdutos.php';
    final response = await http.post(Uri.parse(url), body: {

    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData['result'];    
  }  

  
}
