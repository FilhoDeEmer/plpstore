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
    const url = 'URL para inserir usuário';
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
      Uri.parse("URL de login"),
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

  Future<String> recuperarSenha(String email, String cpf) async {
    String url =
        'URL de recuperação de senha';
    final response = await http.post(Uri.parse(url), body: {});
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData['code'] == 1) {
      return _sendEmail(email, responseData['result'][0]['senha']);
    } else {
      return 'falha';
    }
  }

  Future<String> _sendEmail(String email, String send) async {
    try {
      await emailjs.send(
        'service_4bd585m',
        'template_upxlnrg',
        {
          'to_email': 'email@email.com',
          'message': 'Senha: ${send}',
          'notes': 'PLP Store',
          'from_name': 'PLP Store'
        },
        const emailjs.Options(
            publicKey: '*',
            privateKey: '*',
            limitRate: const emailjs.LimitRate(
              id: 'app',
              throttle: 10000,
            )),
      );
      return 'E-mail de recuperação enviado com sucesso, verifique sua caixa de entrada';
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        return ('ERROR... $error');
      }
      return (error.toString());
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
