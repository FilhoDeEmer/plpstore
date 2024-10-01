import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plpstore/model/product.dart';

class Produtos with ChangeNotifier {
  int cont = 0;

  Future<Map<String, dynamic>> allProducts() async {
    const url = '';
    final response = await http.post(Uri.parse(url));
    final responseData = jsonDecode(response.body);
    Map<String, dynamic> total = await responseData['result'];
    cont = total.length;

    return total;
  }

  Future<Map<String, dynamic>> filterProducts(String term) async {
    const url = '';
    dynamic response = [];
    if (term.isEmpty) {
      response = await http.post(Uri.parse(url));
    } else {
      response = await http.post(Uri.parse(url), body: {'termo': term});
    }
    final responseData = jsonDecode(response.body);
    Map<String, dynamic> total = responseData['result'];
    Map<String, dynamic> resultadoFinal = {};

    total.forEach((categoria, produtos) {
      for (var produto in produtos) {
        resultadoFinal[produto['id'].toString()] = produto;
      }
    });
    return resultadoFinal;
  }
}

class ProductProvider with ChangeNotifier {
  String lengthList = '';

  String contarProdutos() {
    fetchAllProducts('Buscar,');
    return lengthList;
  }

  late Future<List<Product>> _allProductsFuture;

  Future<List<Product>> get allProductsFuture async {
    return _allProductsFuture;
  }

  Future<List<Product>> initializeAllProductsFuture(String categoria) async {
    _allProductsFuture = fetchAllProducts(categoria);
    return _allProductsFuture;
  }

  Future<List<Product>> fetchAllProducts(String categoria) async {
    String result = categoria;
    List<String> list = result.split(',');
    String nome = list[0];

    if (nome == 'Buscar') {
      int number = 0;

      final allProductsData = await Produtos().filterProducts('');
      List<Product> productList = [];

      for (var item in allProductsData.values) {
        number += 1;
        Product product = Product(
          categoria: item['categoria'].toString(),
          subCategoria: item['sub_categoria'].toString(),
          nome: item['nome'].toString(),
          nomeUrl: item['nome_url'].toString(),
          descricao: item['descricao'].toString(),
          descricaoLonga: item['descricao_longa'].toString(),
          valor: item['valor'].toString(),
          imagem: item['imagem'].toString(),
          estoque: item['estoque'].toString(),
          tipoEnvio: item['tipo_envio'].toString(),
          palavras: item['palavras'].toString(),
          ativo: item['ativo'].toString(),
          peso: item['peso'].toString(),
          largura: item['largura'].toString(),
          altura: item['altura'].toString(),
          comprimento: item['comprimento'].toString(),
          modelo: item['modelo'].toString(),
          valorFrete: item['valor_frete'].toString(),
          promocao: item['promocao'].toString(),
          vendas: item['vendas'].toString(),
          categoriaNome: item['categoria_nome'].toString(),
          subCategoriaNome: item['sub_categoria_nome'].toString(),
          link: item['link'].toString(),
          id: item['id'].toString(),
          numero: number.toString(),
        );
        productList.add(product);
      }
      lengthList = productList.length.toString();
      notifyListeners(); 
      return productList;
    }

    int number = 0;
    final allProductsData = await Produtos().allProducts();
    List<Product> productList = [];
    for (var item in allProductsData[categoria]) {
      number += 1;
      Product product = Product(
        categoria: item['categoria'].toString(),
        subCategoria: item['sub_categoria'].toString(),
        nome: item['nome'].toString(),
        nomeUrl: item['nome_url'].toString(),
        descricao: item['descricao'].toString(),
        descricaoLonga: item['descricao_longa'].toString(),
        valor: item['valor'].toString(),
        imagem: item['imagem'].toString(),
        estoque: item['estoque'].toString(),
        tipoEnvio: item['tipo_envio'].toString(),
        palavras: item['palavras'].toString(),
        ativo: item['ativo'].toString(),
        peso: item['peso'].toString(),
        largura: item['largura'].toString(),
        altura: item['altura'].toString(),
        comprimento: item['comprimento'].toString(),
        modelo: item['modelo'].toString(),
        valorFrete: item['valor_frete'].toString(),
        promocao: item['promocao'].toString(),
        vendas: item['vendas'].toString(),
        categoriaNome: item['categoria_nome'].toString(),
        subCategoriaNome: item['sub_categoria_nome'].toString(),
        link: item['link'].toString(),
        id: item['id'].toString(),
        numero: number.toString(),
      );
      productList.add(product);
    }
    return productList;
  }
}
