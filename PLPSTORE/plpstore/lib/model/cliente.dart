

import 'package:flutter/material.dart';

class Cliente with ChangeNotifier{
  String  id;
  String  nome;
  String  email;
  String  cpf;
  String  senha;
  String  senhaCrip;
  String  telefone;
  String  rua;
  String  numero;
  String  complemento;
  String  bairro;
  String  cidade;
  String  estado;
  String  cep;
  String  cartoes;
  bool fistTime;

  Cliente({
  required  this.id,
  required  this.nome,
  required  this.email,
  required  this.cpf,
  required  this.senha,
  required  this.senhaCrip,
  required  this.telefone,
  required  this.rua,
  required  this.numero,
  required  this.complemento,
  required  this.bairro,
  required  this.cidade,
  required  this.estado,
  required  this.cep,
  required  this.cartoes,
  required this.fistTime,
  });

  void atualizarEndereco({
    String? rua,
    String? cidade,
    String? numero,
    String? estado,
    String? cep,
    String? bairro,
    String? telefone,
  }) {
    this.rua = rua ?? this.rua;
    this.cidade = cidade ?? this.cidade;
    this.numero = numero ?? this.numero;
    this.estado = estado ?? this.estado;
    this.cep = cep ?? this.cep;
    this.bairro = bairro ?? this.bairro;
    this.telefone = telefone ?? this.telefone;
    notifyListeners();
  }
  void deslogar() {
  id = '';
  nome= '';
  email= '';
  cpf= '';
  senha= '';
  senhaCrip= '';
  telefone= '';
  rua= '';
  numero= '';
  complemento= '';
  bairro= '';
  cidade= '';
  estado= '';
  cep= '';
  cartoes= '';
  }
}