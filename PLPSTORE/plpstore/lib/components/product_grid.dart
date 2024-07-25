import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/product_grid_item.dart';
import 'package:plpstore/model/product.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  final String colecao;
  const ProductGrid({
    super.key,
    required this.colecao,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

const List<int> list = [24, 50, 100];

class _ProductGridState extends State<ProductGrid> {
  String searchTerm = '';
  bool pokemon = false;
  bool treinador = false;
  bool energia = false;
  bool emEstoque = false;
  late Future<List<Product>> _allProductsFuture;
  final TextEditingController _searchController = TextEditingController();
  int itemsPerPage = 24;
  int currentPage = 1;
  bool _isSearchVisible = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _allProductsFuture =
        productProvider.initializeAllProductsFuture(widget.colecao);

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset == 0) {
      if (!_isSearchVisible) {
        setState(() {
          _isSearchVisible = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isSearchVisible) {
        setState(() {
          _isSearchVisible = false;
        });
      }
    }
  }

  void searchProduct(String term) {
    setState(() {
      pokemon = false;
      treinador = false;
      energia = false;
      searchTerm = term.toLowerCase();
      currentPage = 1;
    });
  }

  void _nextPage() {
    setState(() {
      currentPage++;
    });
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _previousPage() {
    setState(() {
      currentPage--;
    });
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    List<Product> productList;
    return FutureBuilder<List<Product>>(
      future: _allProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          // } else if (snapshot.hasError ) {
          //   return Center(child: Text(snapshot.error.toString())); tem que retornar quandso for fazer teste, mas acho que não vai mais precisar
        } else if (!snapshot.hasData ||
            snapshot.data!.isEmpty ||
            snapshot.hasError) {
          return const Center(child: Text('Nenhum produto encontrado.'));
        } else {
          if (energia) {
            productList = snapshot.data!;
            productList = productList
                .where((product) =>
                    product.subCategoriaNome.toString().contains('Energia'))
                .toList();
          } else if (pokemon) {
            productList = snapshot.data!;
            productList = productList
                .where((product) =>
                    product.subCategoriaNome.toString().contains('Pokemon'))
                .toList();
          } else if (treinador) {
            productList = snapshot.data!;
            productList = productList
                .where((product) =>
                    product.subCategoriaNome.toString().contains('Treinador'))
                .toList();
          } else if (emEstoque) {
            productList = snapshot.data!;
            productList = productList
                .where((product) =>
                    int.parse(product.estoque) > 0 )
                .toList();
          } else {
            productList = snapshot.data!;
            productList = productList
                .where((product) =>
                    product.nome.toString().toLowerCase().contains(searchTerm))
                .toList();
          }

          int totalItems = productList.length;
          int totalPages = (totalItems / itemsPerPage).ceil();
          int startIndex = (currentPage - 1) * itemsPerPage;
          int endIndex = startIndex + itemsPerPage;
          if (endIndex > totalItems) {
            endIndex = totalItems;
          }
          List<Product> paginatedProducts =
              productList.sublist(startIndex, endIndex);
          return Column(
            children: [
              Visibility(
                visible: _isSearchVisible,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        // height: 50,
                        child: widget.colecao.split(',').first != 'Buscar'
                            ? TextField(
                                controller: _searchController,
                                onChanged: searchProduct,
                                decoration: const InputDecoration(
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.searchengin,
                                      color: Colors.black,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  hintText: 'Buscar',
                                ),
                              )
                            : null,
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            value: pokemon,
                            onChanged: (bool? value) {
                              setState(() {
                                energia = false;
                                treinador = false;
                                pokemon = value!;
                                currentPage = 1;
                              });
                            },
                          ),
                          const Text('Pokémon'),
                          Checkbox(
                            checkColor: Colors.white,
                            value: treinador,
                            onChanged: (bool? value) {
                              setState(() {
                                energia = false;
                                pokemon = false;
                                treinador = value!;
                                currentPage = 1;
                              });
                            },
                          ),
                          const Text('Treinador'),
                          Checkbox(
                            checkColor: Colors.white,
                            value: energia,
                            onChanged: (bool? value) {
                              setState(() {
                                treinador = false;
                                pokemon = false;
                                energia = value!;
                                currentPage = 1;
                              });
                            },
                          ),
                          const Text('Energia'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Checkbox(
                              checkColor: Colors.white,
                              value: emEstoque,
                              onChanged: (bool? value) {
                                setState(() {
                                  emEstoque = value!;
                                  currentPage = 1;
                                });
                              },
                            ),
                            const Text('Em estoque'),
                            const Text('Produtos por página'),
                            
                    DropdownButton(
                        value: itemsPerPage,
                        items: list.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            currentPage = 1;
                            itemsPerPage = value!;
                          });
                        }),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: paginatedProducts.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) => ProductGridItem(
                    data: paginatedProducts[index],
                  ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: currentPage > 1 ? _previousPage : null,
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft)
                  ),
                  Text('Página $currentPage de $totalPages'),
                  IconButton(
                    onPressed: currentPage < totalPages ? _nextPage : null,
                    icon: const FaIcon(FontAwesomeIcons.arrowRight),
                  ),
                    
                  ],
                ),
            ],
          );
        }
      },
    );
  }
}
