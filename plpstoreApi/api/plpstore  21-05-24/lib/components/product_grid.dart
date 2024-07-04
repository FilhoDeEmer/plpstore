import 'package:flutter/material.dart';
import 'package:plpstore/components/product_grid_item.dart';
import 'package:plpstore/model/product.dart';

class ProductGrid extends StatefulWidget {
  final List<dynamic> colection;
  final String colecao;
  final String idColection;
  const ProductGrid({super.key, required this.colection, required this.colecao, required this.idColection});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

void searchProduct() {}

Future<List<Product>> fetchDataOrSearch(
    String searchProduct, List<dynamic> colection) async {
  int number = 0;
  List<Product> filteredProduct = [];
  for (var item in colection) {
    number += 1;
    Product product = Product(
      categoria: item['categoria'].toString(),
      subCategoria: item['subCategoria'].toString(),
      nome: item['nome'].toString(),
      nomeUrl: item['nomeUrl'].toString(),
      descricao: item['descricao'].toString(),
      descricaoLonga: item['descricaoLonga'].toString(),
      valor: item['valor'].toString(),
      imagem: item['imagem'].toString(),
      estoque: item['estoque'].toString(),
      tipoEnvio: item['tipoEnvio'].toString(),
      palavras: item['palavras'].toString(),
      ativo: item['ativo'].toString(),
      peso: item['peso'].toString(),
      largura: item['largura'].toString(),
      altura: item['altura'].toString(),
      comprimento: item['comprimento'].toString(),
      modelo: item['modelo'].toString(),
      valorFrete: item['valorFrete'].toString(),
      promocao: item['promocao'].toString(),
      vendas: item['vendas'].toString(),
      categoriaNome: item['categoriaNome'].toString(),
      subCategoriaNome: item['subCategoriaNome'].toString(),
      link: item['link'].toString(),
      id: item['id'].toString(),
      numero: number.toString(),
    );
    if (product.id.toLowerCase().contains(searchProduct.toLowerCase())) {
      filteredProduct.add(product);
    }
  }
  return filteredProduct;
}

class _ProductGridState extends State<ProductGrid> {
  String product = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchDataOrSearch(product, widget.colection),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          List<dynamic> productList = snapshot.data!;
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: searchProduct,
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                    border: OutlineInputBorder(),
                    hintText: 'Buscar',
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: productList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) =>
                        ProductGridItem(data: productList[index], colecao: widget.colecao, idColection: widget.idColection,)),
              ),
            ],
          );
        }
      },
    );
  }
}
