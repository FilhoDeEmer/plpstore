import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String categoria;
  final String subCategoria;
  final String nome;
  final String nomeUrl;
  final String descricao;
  final String descricaoLonga;
  final String valor;
  final String imagem;
  final String estoque;
  final String tipoEnvio;
  final String palavras;
  final String ativo;
  final String peso;
  final String largura;
  final String altura;
  final String comprimento;
  final String modelo;
  final String valorFrete;
  final String promocao;
  final String vendas;
  final String categoriaNome;
  final String subCategoriaNome;
  final String link;
  final String numero;

  Product({
    required this.categoria,
    required this.subCategoria,
    required this.nome,
    required this.nomeUrl,
    required this.descricao,
    required this.descricaoLonga,
    required this.valor,
    required this.imagem,
    required this.estoque,
    required this.tipoEnvio,
    required this.palavras,
    required this.ativo,
    required this.peso,
    required this.largura,
    required this.altura,
    required this.comprimento,
    required this.modelo,
    required this.valorFrete,
    required this.promocao,
    required this.vendas,
    required this.categoriaNome,
    required this.subCategoriaNome,
    required this.link,
    required this.id,
    required this.numero,
  });
}
