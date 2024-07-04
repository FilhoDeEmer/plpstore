import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/take_picture.dart';
import 'package:plpstore/model/auth.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  
  File? _profileImage;
  TakePickture take = TakePickture();

  _takePicture() async {
    File? picture = await take.takePicture();
    setState(() {
      _profileImage = picture;
    });
  }

  _takeGallery() async {
    File? picture = await take.takePicture(fromGallery: true);
    setState(() {
      _profileImage = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _showEditPicture(context);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage == null
                      ? const AssetImage('assets/img/profile.png')
                      : Image.file(
                          _profileImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ).image,
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  offset: const Offset(0, 3),
                                  blurRadius: 3,
                                  spreadRadius: 0)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(
                                'Total de Pedidos',
                                '0',
                                Colors.blue.shade900,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.green.withOpacity(0.2),
                                  offset: const Offset(0, 3),
                                  blurRadius: 3,
                                  spreadRadius: 0)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(
                                'Pedidos Finalizados',
                                '0',
                                Colors.green.shade900,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.red.withOpacity(0.2),
                                  offset: const Offset(0, 3),
                                  blurRadius: 3,
                                  spreadRadius: 0)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(
                                'Pedidos Pendentes',
                                '0',
                                Colors.red.shade900,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.amber.withOpacity(0.2),
                                offset: const Offset(0, 3),
                                blurRadius: 3,
                                spreadRadius: 0)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGridItem(
                              'Aguardando Entrega',
                              '0',
                              Colors.amber.shade900,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Minhas Informações',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.pen))
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: Divider(
                  color: Colors.blue,
                  height: 1,
                  thickness: 3,
                ),
              ),
              Text('Usuário: ${user.getName()}'),
               Text('E-mail: ${user.getEmail()}'),
               Text('CPF: ${user.getCpf()}'),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Endereço',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.pen))
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: Divider(
                  color: Colors.blue,
                  height: 1,
                  thickness: 3,
                ),
              ),
              const Text('Rua : José Luis De Brito'),
              const Text('Número: 110'),
              const Text('Cidade: Jacarei'),
              const Text('Estado: São Paulo'),
            ],
          ),
        ),
      ),
    );
  }

//metodos
  void _showEditPicture(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar foto de perfil!'),
          content: const Text('Escolha uma opção'),
          actions: [
            TextButton(
              onPressed: () {
                _takeGallery();
                Navigator.of(context).pop();
              },
              child: const Text('Selecionar da Galeria'),
            ),
            TextButton(
              onPressed: () {
                _takePicture();
                Navigator.of(context).pop();
              },
              child: const Text('Tirar Foto'),
            )
          ],
        );
      },
    );
  }

  Widget _buildGridItem(
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          const SizedBox(height: 4),
          Center(child: Text(value)),
        ],
      ),
    );
  }
}
