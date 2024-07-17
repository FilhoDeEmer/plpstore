import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plpstore/model/cliente.dart';

class GetCliente with ChangeNotifier {
  Cliente? _cliente;
  Cliente? get cliente => _cliente;
  late int code;
  late String _message;

  String generateMs5(String senha) {
    return md5.convert(utf8.encode(senha)).toString();
  }

  bool comparePasswird(String input, String hashedSenha) {
    String hashInput = generateMs5(input);
    return hashedSenha == hashInput;
  }

  Future<void> pegaClients(String cpf) async {
    const url = 'https://plpstore.com.br/apis/api/login/clientes.php';
    final response = await http.post(Uri.parse(url), body: {'cpf': cpf});
    final responseData = jsonDecode(response.body);

    if (responseData['code'] == 1) {
      Map<String, dynamic> total = responseData['result'];
      _cliente = Cliente(
        nome: total['nome'].toString(),
        cpf: total['cpf'].toString(),
        id: total['id'].toString(),
        email: total['email'].toString(),
        senha: total['senha'].toString(),
        senhaCrip: total['senha_Crip'].toString(),
        telefone: total['telefone'].toString(),
        rua: total['rua'].toString(),
        numero: total['numero'].toString(),
        complemento: total['complemento'].toString(),
        bairro: total['bairro'].toString(),
        cidade: total['cidade'].toString(),
        estado: total['estado'].toString(),
        cep: total['cep'].toString(),
        cartoes: total['cartoes'].toString(),
        fistTime: total['cep'] == null ? true : false,
      );

      notifyListeners();
    } else {
      _message = responseData['result'];
    }
  }

  Future<void> vendasClients(String idUser) async {
    const url = 'https://plpstore.com.br/apis/api/vendas/vendasClientes.php';
    final response =
        await http.post(Uri.parse(url), body: {'idUsuario': idUser});
    final responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData['code'] == 1) {
      notifyListeners();
    } else {
      _message = responseData['result'];
    }
  }

  Future<void> atualizarCliente(Cliente cliente) async {
    const url = 'https://plpstore.com.br/apis/api/usuarios/atualizar.php';
    final response = await http.post(Uri.parse(url), body: {
      'nome': cliente.nome,
      'email': cliente.email,
      'cpf': cliente.cpf,
      'telefone': cliente.telefone,
      'rua': cliente.rua,
      'numero': cliente.numero,
      'complemento': cliente.complemento,
      'bairro': cliente.bairro,
      'cidade': cliente.cidade,
      'estado': cliente.estado,
      'cep': cliente.cep,
    });
    final responseData = jsonDecode(response.body);
    if (responseData['code'] == 1) {
      code = responseData['code'];
      _message = responseData['message'];
    } else {
      _message = responseData['message'];
    }
    notifyListeners();
  }

  String getMessage() {
    return _message;
  }

  void sair() {
    cliente?.deslogar();
    notifyListeners();
  }
}
