import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/utils/app_routes.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

final TextEditingController _searchController = TextEditingController();

class _PrincipalPageState extends State<PrincipalPage> {
  String searchTerm = '';
  void searchProduct() {
    String term = _searchController.text;
    if (term.isNotEmpty) {
      setState(() {
        searchTerm = term.toLowerCase();
      });
      String list = 'Buscar,$term';
      Navigator.of(context).pushNamed(
        AppRoutes.colection,
        arguments: list,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, insira uma palavra para pesquisa')),
      );
    }
  }
  

  String page = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.checkout);
                },
                child: const Text('Teste de integração')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchProduct();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.searchengin,
                          color: Colors.black,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      hintText: 'Buscar'),
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
                                    page = 'Fenda Paradoxal';
                                  } else if (imgUrl ==
                                      'assets/img/sv04pt5_logo_nav.png') {
                                    page = 'Destinos de Paldea';
                                  } else if (imgUrl ==
                                      'assets/img/sv05_logo_nav.png') {
                                    page = 'Forças Temporais';
                                  } else {
                                    page = 'Home';
                                  }
                                });
                                Navigator.of(context).pushNamed(
                                    AppRoutes.colection,
                                    arguments: page);
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
                autoPlayCurve: Curves.ease,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: carouselCard.map((imgUrl) {
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
                        ),
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
              'Mais Vendidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 150,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 1.0,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
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
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 150,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 1.0,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
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
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
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

  final List<String> carouselCard = [
    'assets/img/tcg_card_back.jpg',
    'assets/img/tcg_card_back.jpg',
    'assets/img/tcg_card_back.jpg',
    'assets/img/tcg_card_back.jpg',
  ];
}
