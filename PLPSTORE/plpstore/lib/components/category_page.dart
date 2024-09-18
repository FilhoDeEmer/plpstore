import 'package:flutter/material.dart';
import 'package:plpstore/utils/app_routes.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300, // Largura máxima do item
            childAspectRatio: 3 / 2, // Razão de aspecto do item
            crossAxisSpacing: 10, // Espaçamento entre colunas
            mainAxisSpacing: 10, // Espaçamento entre linhas
          ),
          children: [
            _buildCategoryCard(
              context,
              'Coroa Estelar',
              'assets/img/coroa_estelar_baner.png',
            ),
            _buildCategoryCard(
              context,
              'Mascaras do Crepúsculo',
              'assets/img/mascaras_colecao.jpg',
            ),
            _buildCategoryCard(
              context,
              'Forças Temporais',
              'assets/img/forcas_colecao.jpg',
            ),
            _buildCategoryCard(
              context,
              'Destinos de Paldea',
              'assets/img/destinos_colecao.jpg',
            ),
            _buildCategoryCard(
              context,
              'Fenda Paradoxal',
              'assets/img/fenda_colecao.jpg',
            ),
            _buildCategoryCard(
              context,
              'Escarlate e Violeta 151',
              'assets/img/mew_colecao.jpg',
            ),
            _buildCategoryCard(
              context,
              'Todas as Cartas...',
              null, // Nenhuma imagem para este item
              isSearch: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String? imagePath, {
    bool isSearch = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.colection,
          arguments: title == 'Todas as Cartas...' ? 'Buscar,' : title,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isSearch
              ? Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
