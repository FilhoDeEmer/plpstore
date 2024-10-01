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
      case 'assets/img/coroa_estelar.png':
        page = 'Coroa Estelar';
        break;
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
        height: MediaQuery.of(context).size.height * 0.35,
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.easeInOut,
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
                      'URL da imegem',
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(nome,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.04)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('R\$ $valor',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04)),
                      Text('UN.:$estoque',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04)),
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
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: deviceHeight * 0.2,
                  autoPlay: false,
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
                            width: deviceWidth,
                            margin: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.02),
                            decoration: const BoxDecoration(
                              color: Colors.white,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth * 0.02,
                                  vertical: deviceHeight * 0.01),
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.1, vertical: deviceHeight * 0.02),
              child: const Divider(
                color: Color.fromRGBO(212, 175, 55, 1),
                height: 1,
                thickness: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.03),
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.1, vertical: deviceHeight * 0.02),
              child: const Divider(
                color: Color.fromRGBO(212, 175, 55, 1),
                height: 1,
                thickness: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.03),
              child: const Text(
                'Novidades Pokémon',
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
                  return _buildProductCarousel(products, _novidadesPokemon);
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.1, vertical: deviceHeight * 0.02),
              child: const Divider(
                color: Color.fromRGBO(212, 175, 55, 1),
                height: 1,
                thickness: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.03),
              child: const Text(
                'Novidades Treinador',
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
    'assets/img/coroa_estelar.png',
    'assets/img/sv06_logo_nav.png',
    'assets/img/sv04_logo_nav.png',
    'assets/img/sv04pt5_logo_nav.png',
    'assets/img/sv05_logo_nav.png',
  ];
}
