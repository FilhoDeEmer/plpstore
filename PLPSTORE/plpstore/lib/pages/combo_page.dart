import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/cad_combo.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/produtos_list.dart';
import 'package:plpstore/pages/edit_product_combo_page.dart';
import 'package:provider/provider.dart';

class ComboPage extends StatefulWidget {
  const ComboPage({super.key});

  @override
  State<ComboPage> createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> {
  
  late Future<Map<String, dynamic>> _collectionsFuture;

  @override
  void initState() {
    super.initState();
    _collectionsFuture = Provider.of<Produtos>(context, listen: false)
        .allProducts(); // mudar para link de combos
  }

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
          'Combos',
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
            return const Center(child: PokeballLoading());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar combos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum combo encontrado'));
          } else {
            Map<String, dynamic> collectionsMap = snapshot.data!;
            List<String> collections = collectionsMap.keys.toList();
            return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: collections.map((colecao) {
                      return Dismissible(
                        key: ValueKey(collectionsMap.keys),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: const FaIcon(
                            FontAwesomeIcons.trashCan,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        confirmDismiss: (_) {
                          return showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Deletar Combo'),
                              content: const Text(
                                  'O combo será excluido, deseja continuar?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                    child: const Text('Cancelar')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(true);
                                    },
                                    child: const Text('Sim')),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) {
                          //função para deletar
                        },
                        child: Card(
                          child: ListTile(
                            title: Text('Nome do Combo'),
                            leading: FaIcon(
                              FontAwesomeIcons.solidSquare,
                              color: Colors.green,
                            ),
                            trailing: Column(
                              children: [
                                GestureDetector(child: FaIcon(FontAwesomeIcons.pen, color: Colors.blue,), onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditComboProductPage()));// lembrar que tem que passar as informações do combo
                                },),
                                const SizedBox(height: 10,),
                                const Text('Editar Itens', style: TextStyle(fontSize: 9),)
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text('R\$600,00'),
                                SizedBox(width: 10,),
                                Text('Itens: 40'),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ComboEdit(edit: 1,),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            );
          }
        },
      ),
    );
  }
}
