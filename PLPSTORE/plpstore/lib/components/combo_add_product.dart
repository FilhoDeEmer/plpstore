import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/combo_list.dart';
import 'package:plpstore/model/product.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:provider/provider.dart';

class ComboAddProduct extends StatefulWidget {
  const ComboAddProduct({super.key});

  @override
  State<ComboAddProduct> createState() => _ComboAddProductState();
}

const List<int> list = [24, 50, 100];

class _ComboAddProductState extends State<ComboAddProduct> {
  String searchTerm = '';
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
    _allProductsFuture = productProvider.initializeAllProductsFuture('Buscar,');

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
    final comboList = Provider.of<ComboList>(context, listen: false);

    List<Product> productList;
    return FutureBuilder<List<Product>>(
      future: _allProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: PokeballLoading());

        } else if (!snapshot.hasData ||
            snapshot.data!.isEmpty ||
            snapshot.hasError) {
          return const Center(child: Text('Nenhum produto encontrado.'));
        } else {
          productList = snapshot.data!;
          productList = productList
              .where((product) =>
                  product.nome.toString().toLowerCase().contains(searchTerm))
              .toList();

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
                          child: TextField(
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
                          )),
                    ),
                  ],
                ),
              ),
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
                },
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: paginatedProducts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(paginatedProducts[index].descricao),
                          subtitle: Row(
                            children: [
                              Text('R\$ ${paginatedProducts[index].valor}'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Un.: ${paginatedProducts[index].estoque}'),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                if (int.parse(
                                        paginatedProducts[index].estoque) ==
                                    0) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sem estoque!'),
                                      duration: Duration(seconds: 1),
                                      action: null,
                                    ),
                                  );
                                } else {
                                  comboList.addItem(paginatedProducts[index]);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Produto adicionado com sucesso!'),
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: 'DESFAZER',
                                        onPressed: () {
                                          comboList.removeSingleItem(paginatedProducts[index].id);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.plus,
                                color: Colors.green,
                              )),
                        ),
                      );
                    }),
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
    );
  }
}
