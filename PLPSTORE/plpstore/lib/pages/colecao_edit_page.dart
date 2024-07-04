import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:provider/provider.dart';

class ColecaoEditPage extends StatefulWidget {
  const ColecaoEditPage({super.key});

  @override
  State<ColecaoEditPage> createState() => _ColecaoEditPageState();
}

class _ColecaoEditPageState extends State<ColecaoEditPage> {
  late Future<Map<String, dynamic>> _collectionsFuture;

  @override
  void initState() {
    super.initState();
    _collectionsFuture = Provider.of<Produtos>(context, listen: false).allProducts();
  }

  final Map<String, String> imageUrls = {
    'Destinos de Paldea': 'https://plpstore.com.br/img/categorias/16-04-2024-19-34-58-sv04pt5-logo-nav.png',
    'Forças Temporais': 'https://plpstore.com.br/img/categorias/16-04-2024-19-33-58-sv5-logo.png',
    'Fenda Paradoxal': 'https://plpstore.com.br/img/categorias/21-04-2024-15-34-00-fenda.png',
    'Escarlate e Violeta 151': 'https://plpstore.com.br/img/categorias/17-04-2024-10-03-26-151.png',
    'Produtos Fechados': 'https://plpstore.com.br/img/categorias/30-04-2024-11-37-40-boosters.png',
    'Mascaras do Crepusculo': 'https://plpstore.com.br/img/categorias/31-05-2024-10-17-54-MascaraCorreta.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text(
          'Administração',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _collectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar coleções'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma coleção encontrada'));
          } else {
            Map<String, dynamic> collectionsMap = snapshot.data!;
            List<String> collections = collectionsMap.keys.toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 200,
                  ),
                  itemCount: collections.length + 1,
                  itemBuilder: (context, index) {
                    if (index == collections.length) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(context: context, builder: (BuildContext context) => dialogBox(context, 'Nova Coleção'));
                        },
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Nova Coleção +',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      String collection = collections[index];
                      return GestureDetector(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: imageUrls.containsKey(collection)
                                ? Image.network(
                                    imageUrls[collection]!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: Icon(Icons.error));
                                    },
                                  )
                                : const Center(child: Icon(Icons.image_not_supported)),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => dialogBox(context, collection),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

Widget dialogBox(BuildContext context, String colecao) {
  return AlertDialog(
    backgroundColor: Colors.white,
    content: SizedBox(
      width: 250,
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: colecao,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Adicionar a ação de salvar
                  },
                  child: const Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
