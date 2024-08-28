import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/product.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:plpstore/pages/product_detail_page.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late Future<List<Product>> _allProduct;
  late List<String> _highlightedProductIds;
  late List<String> _novidadesPokemon;
  late List<String> _novidadesTreinador;

  @override
  void initState() {
    super.initState();
    _highlightedProductIds = [
      '213',
      '212',
      '200',
      '671'
    ]; // IDs dos produtos em destaque
    _novidadesPokemon = [
      '956',
      '955',
      '946',
      '937'
    ]; // IDs dos produtos em novidades Pokémon
    _novidadesTreinador = [
      '997',
      '998',
      '993',
      '992'
    ]; // IDs dos produtos em novidades Treinador
    _allProduct = _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return await productProvider.fetchAllProducts('Buscar, ');
  }

  void _onImageTap(String imgUrl) {
    String page;
    switch (imgUrl) {
      case 'assets/img/sv06_logo_nav.png':
        page = 'Mascaras do Crepúsculo';
        break;
      case 'assets/img/sv04_logo_nav.png':
        page = 'Fenda Paradoxal';
        break;
      case 'assets/img/sv04pt5_logo_nav.png':
        page = 'Destinos de Paldea';
        break;
      case 'assets/img/sv05_logo_nav.png':
        page = 'Forças Temporais';
        break;
      default:
        page = 'Home';
    }
    Navigator.of(context)
        .pushReplacementNamed(AppRoutes.colection, arguments: page);
  }

  Widget _buildProductCarousel(
      List<Product> products, List<String> productIds) {
    final produtosDestaque =
        products.where((product) => productIds.contains(product.id)).toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 280,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.ease,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: produtosDestaque.map((product) {
        final imgUrl = product.imagem;
        final nome = product.nome;
        final valor = product.valor;
        final estoque = product.estoque;

        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetail(
                      data: product,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://plpstore.com.br/img/produtos/$imgUrl',
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Text(nome,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('R\$ $valor',
                          style: const TextStyle(color: Colors.green)),
                      Text('UN.:$estoque',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: carouselImg.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  _onImageTap(imgUrl);
                                },
                                child: const Text('Ver coleção'),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Divider(
                color: Color.fromRGBO(212, 175, 55, 1),
                height: 1,
                thickness: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Produtos em Destaque',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<Product>>(
              future: _allProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: PokeballLoading());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum produto encontrado.'));
                } else {
                  final products = snapshot.data!;
                  return _buildProductCarousel(
                      products, _highlightedProductIds);
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Divider(
                color: Color.fromRGBO(212, 175, 55, 1),
                height: 1,
                thickness: 3,
              ),
            ),
            const Text(
              'Novidades Pokémon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Product>>(
              future: _allProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: PokeballLoading());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum produto encontrado.'));
                } else {
                  final products = snapshot.data!;
                  return _buildProductCarousel(products, _novidadesPokemon);
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Divider(
                color: Color.fromRGBO(212, 175, 55, 1),
                height: 1,
                thickness: 3,
              ),
            ),
            const Text(
              'Novidades Treinador',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Product>>(
              future: _allProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: PokeballLoading());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum produto encontrado.'));
                } else {
                  final products = snapshot.data!;
                  return _buildProductCarousel(products, _novidadesTreinador);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  final List<String> carouselImg = [
    'assets/img/sv06_logo_nav.png',
    'assets/img/sv04_logo_nav.png',
    'assets/img/sv04pt5_logo_nav.png',
    'assets/img/sv05_logo_nav.png',
  ];
}
