import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token = '';
  String _level = '';
  String _email = '';
  String _userId = '';
  String _name = '';
  String _cpf = '';
  Image? _profileImage = null;

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
    int code = responseData['code'];
    if (response.statusCode == 200) {
      return code;
    } else {
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
    setUser(responseData);
    int code = responseData['code'];
    if (response.statusCode == 200) {
      return code;
    } else {
      return code;
    }
  }

  void setUser(Map user) {
    _token = user['result']['email'].toString();
    _level = user['result']['nivel'].toString();
    _email = user['result']['email'].toString();
    _userId = user['result']['id'].toString();
    _name = user['result']['nome'].toString();
    _cpf = user['result']['cpf'].toString();
    _profileImage = user['result']['imagem'];
    notifyListeners();
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
  String getName() {
    return _name;
  }
  String getCpf() {
    return _cpf;
  }
  Image? getPicture() {
    return _profileImage;
  }
  void logout() {
    _token = '';
    _level = '';
    _email = '';
    _userId = '';
    _name = '';
    _cpf = '';
    _profileImage = null;
    notifyListeners();
  }
}
