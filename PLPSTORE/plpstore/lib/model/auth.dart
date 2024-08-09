import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plpstore/model/get_clientes.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class Auth with ChangeNotifier {
  String _token = '';
  String _level = ''; // Cliente, Admin
  String _email = '';
  String _userId = '';
  String _name = '';
  String _cpf = '';
  String? _profileImage = '';
  String _mensagem = '';
  late int code;

  Future<int> signup(
    String email,
    String password,
    String nome,
    String cpf,
  ) async {
    const url = 'https://plpstore.com.br/apis/api/usuarios/inserir.php';
    final response = await http.post(Uri.parse(url), body: {
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'senha': password,
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData['code'] == 0) {
      code = responseData['code'];
      _mensagem = responseData['message'];
      return code;
    } else {
      code = responseData['code'];
      return code;
    }
  }

  Future<int> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("https://plpstore.com.br/apis/api/login/login.php"),
      body: {
        'email': email,
        'senha': password,
      },
    );
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData['code'] == 0) {
      code = responseData['code'];
      _mensagem = responseData['result'];
      return code;
    } else {
      code = responseData['code'];
      setUser(responseData['result']);
      return code;
    }
  }

  void setUser(Map user) {
    GetCliente iniciar = GetCliente();
    iniciar.pegaClients(user['cpf']);
    _token = user['email'].toString();
    _level = user['nivel'].toString();
    // _level = 'Admin';
    _email = user['email'].toString();
    _userId = user['id'].toString();
    _name = user['nome'].toString();
    _cpf = user['cpf'].toString();
    _profileImage = user['imagem'];
    notifyListeners();
  }

  Future<void> recuperarSenha(String email, String cpf) async {
    String url =
        'https://plpstore.com.br/apis/api/usuarios/recuperarSenha.php?emailUsuario=${email}&cpfUsuario=${cpf}';
    final response = await http.post(Uri.parse(url), body: {});
    Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData['code'] == 1) {
      _sendEmail(email, responseData['result'][0]['senha']);
    } else {
      print(responseData);
    }
  }

  Future<void> _sendEmail(String email, String send) async {
    try {
      await emailjs.send(
        'YOUR_SERVICE_ID',
        'YOUR_TEMPLATE_ID',
        {
          'to_email': email,
          'message': 'E-mail de recuperação de senha: ${send}',
        },
        const emailjs.Options(
            publicKey: 'YOUR_PUBLIC_KEY',
            privateKey: 'YOUR_PRIVATE_KEY',
            limitRate: const emailjs.LimitRate(
              id: 'app',
              throttle: 10000,
            )),
      );
      print('SUCCESS!');
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        print('ERROR... $error');
      }
      print(error.toString());
    }
  }

  String getToken() {
    return _token;
  }

  String getLevel() {
    return _level;
  }

  String getEmail() {
    return _email;
  }

  String getUserId() {
    return _userId;
  }

  String getMensagem() {
    return _mensagem;
  }

  String getName() {
    return _name;
  }

  String getCpf() {
    return _cpf;
  }

  String? getPicture() {
    return _profileImage;
  }

  void logout() {
    _token = '';
    _level = '';
    _email = '';
    _userId = '';
    _name = '';
    _cpf = '';
    _profileImage = '';
    notifyListeners();
  }
}
