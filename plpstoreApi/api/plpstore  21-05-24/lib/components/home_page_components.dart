import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:plpstore/components/product_grid.dart';
import 'package:plpstore/model/produtos_list.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late Future<Map<String, dynamic>> _allProductsFuture;
  String page = 'Home';

  @override
  void initState() {
    super.initState();
    _allProductsFuture = getAllProduct();
  }

  Future<Map<String, dynamic>> getAllProduct() async {
    return await Produtos().allProducts();
  }

  Widget _buildPageContent(Map<String, dynamic> allProducts) {
    switch (page) {
      case 'Home':
        return const Center(
          child: Text('Home Page'),
        );
      case 'Mascaras do Crepúsculo':
        // Navigator.of(context).pushNamed(ProductGrid(
        //     colection: allProducts['Mascaras do Crepúsculo'],
        //     colecao: 'twilight-masquerade',
        //     idColection: 'SV06'));
      return ProductGrid(
        colection: allProducts['Mascaras do Crepúsculo'],
        colecao: 'twilight-masquerade',
        idColection: 'SV06',
      );
      case 'Forças Temporais':
        return ProductGrid(
          colection: allProducts['Forças Temporais'],
          colecao: 'temporal-forces',
          idColection: 'SV05',
        );
      case 'Destinos de Paldea':
        return ProductGrid(
          colection: allProducts['Destinos de Paldea'],
          colecao: 'paldean-fates',
          idColection: 'SV4pt5',
        );
      case 'Fenda Paradoxal':
        return ProductGrid(
          colection: allProducts['Fenda Paradoxal'],
          colecao: 'paradox-rift',
          idColection: 'SV04',
        );
      case 'Escarlate e Violeta 151':
        return ProductGrid(
          colection: allProducts['Escarlate e Violeta 151'],
          colecao: '151',
          idColection: 'SV3pt5',
        );
      case 'Produtos':
        return const Center(
          child: Text('Produtos'),
        );
      default:
        return const Center(
          child: Text('Página não encontrada'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _allProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar produtos'));
        } else if (snapshot.hasData) {
          final allProducts = snapshot.data!;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchProduct,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 600),
                      viewportFraction: 0.8,
                    ),
                    items: carouselImg.map((imgUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    imgUrl,
                                    fit: BoxFit.scaleDown,
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
                                      setState(() {
                                        if (imgUrl ==
                                            'assets/img/sv06_logo_nav.png') {
                                          page = 'Mascaras do Crepúsculo';
                                        } else if (imgUrl ==
                                            'assets/img/sv04_logo_nav.png') {
                                          page = 'Forças Temporais';
                                        } else if (imgUrl ==
                                            'assets/img/sv04pt5_logo_nav.png') {
                                          page = 'Destinos de Paldea';
                                        } else if (imgUrl ==
                                            'assets/img/sv05_logo_nav.png') {
                                          page = 'Fenda Paradoxal';
                                        } else {
                                          page = 'Home';
                                        }
                                      });
                                    },
                                    child: const Text('Saiba mais!'),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                    child: Divider(
                      color: Colors.blue,
                      height: 1,
                      thickness: 3,
                    ),
                  ),
                  const Text(
                    'Produtos em Destaque',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 600),
                      viewportFraction: 0.8,
                    ),
                    items: carouselCard.map((imgUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    imgUrl,
                                    fit: BoxFit.scaleDown,
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
                                    onPressed: () {},
                                    child: const Text('Saiba mais!'),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                    child: Divider(
                      color: Colors.blue,
                      height: 1,
                      thickness: 3,
                    ),
                  ),
                  _buildPageContent(allProducts),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('Nenhum dado disponível'));
        }
      },
    );
  }
}

void searchProduct() async {
  // Implementar funcionalidade de busca
}

final List<String> carouselImg = [
  'assets/img/sv06_logo_nav.png',
  'assets/img/sv04_logo_nav.png',
  'assets/img/sv04pt5_logo_nav.png',
  'assets/img/sv05_logo_nav.png',
];

final List<String> carouselCard = [
  'assets/img/tcg_card_back.jpg',
  'assets/img/tcg_card_back.jpg',
  'assets/img/tcg_card_back.jpg',
  'assets/img/tcg_card_back.jpg',
];
