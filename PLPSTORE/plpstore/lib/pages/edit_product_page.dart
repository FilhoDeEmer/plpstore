import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/product.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:plpstore/pages/edit_detail_product_page.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  int totalProdutos = 0;
  String searchTerm = '';
  bool pokemon = false;
  bool treinador = false;
  bool energia = false;
  late Future<List<Product>> _allProductsFuture;
  final TextEditingController _searchController = TextEditingController();
  int itemsPerPage = 25;
  int currentPage = 1;
  bool _isSearchVisible = true;
  late ScrollController _scrollController;
  String categoria = '';
  final List<String> categorias = [
    'Todos os Itens',
    'Mascaras do Crepúsculo',
    'Forças Temporais',
    'Destinos de Paldea',
    'Fenda Paradoxal',
    'Escarlate e Violeta 151',
  ];
  final List<int> itemnsPagina = [25, 30, 50, 100];

  @override
  void initState() {
    super.initState();

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _allProductsFuture = productProvider.initializeAllProductsFuture('Buscar,');

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
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

  List<Product> filterProducts(String category, List<Product> allProducts) {
    currentPage = 1;
    if (category == 'Todos os Itens') {
      return allProducts;
    } else {
      return allProducts
          .where((product) =>
              product.categoriaNome.toLowerCase().contains(category))
          .toList();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Produtos',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditDetailProductPage(
                              edit: 0,
                              total: totalProdutos,
                            )));
              },
              icon: const FaIcon(FontAwesomeIcons.plus)),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _allProductsFuture,
        builder: (context, snapshot) {
          totalProdutos = snapshot.data == null ? 0 : snapshot.data!.length;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: PokeballLoading());
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty ||
              snapshot.hasError) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          } else {
            List<Product> productList = snapshot.data!;
            productList = productList
                .where((product) =>
                    product.nome.toLowerCase().contains(searchTerm))
                .toList();
            if (categoria != 'Todos os Itens') {
              productList = productList
                  .where((product) => product.categoriaNome
                      .toLowerCase()
                      .contains(categoria.toLowerCase()))
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: searchProduct,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchProduct(_searchController.text);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.searchengin,
                          color: Colors.black,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      hintText: 'Buscar',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: categoria.isEmpty ? 'Todos os Itens' : categoria,
                        items: categorias.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            categoria = newValue!;
                          });
                          _scrollController.animateTo(0.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                          currentPage = 1;
                        },
                      ),
                    ),
                    DropdownButton(
                      hint: Text(itemsPerPage.toString()),
                      items: itemnsPagina.map((int value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          itemsPerPage = newValue!;
                        });
                        _scrollController.animateTo(0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                        currentPage = 1;
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: paginatedProducts.length,
                    itemBuilder: (context, index) {
                      Product product = paginatedProducts[index];
                      TextEditingController valorController =
                          TextEditingController(text: product.valor);
                      TextEditingController estoqueController =
                          TextEditingController(text: product.estoque);
                      return Card(
                        child: ListTile(
                          title: Text(product.descricao),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('Qnt.:'),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) {},
                                      controller: estoqueController,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Preço: '),
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {},
                                      controller: valorController,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    //função salvar só para estoque e valor
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.floppyDisk,
                                    color: Colors.green,
                                  ))
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDetailProductPage(
                                  produto: product,
                                  edit: 1,
                                  total: totalProdutos,
                                ),
                              ),
                            );
                            //função salvar
                          },
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: currentPage > 1 ? _previousPage : null,
                        icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
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
      ),
    );
  }
}
