import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/take_picture.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/cliente.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:provider/provider.dart';
// teste de git
class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _profileImage;
  TakePickture take = TakePickture();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<Auth>(context, listen: false);
    await Provider.of<GetCliente>(context, listen: false)
        .pegaClients(userProvider.getCpf());
  }

  @override
  Widget build(BuildContext context) {
    final cliente = Provider.of<GetCliente>(context).cliente;

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showEditPicture(context),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage == null
                      ? const AssetImage('assets/img/profile.png')
                      : Image.file(
                          _profileImage!,
                          fit: BoxFit.cover,
                        ).image,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGridItem('Total de Pedidos', '0', Colors.blue.shade900),
                  _buildGridItem('Pedidos Finalizados', '0', Colors.green.shade900),
                  _buildGridItem('Pedidos Pendentes', '0', Colors.red.shade900),
                  _buildGridItem('Aguardando Entrega', '0', Colors.amber.shade900),
                ],
              ),
              const SizedBox(height: 20),
              cliente != null ? _buildClientInfo(cliente) : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
              cliente != null ? _buildAddressInfo(context, cliente) : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String label, String value, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.2),
                offset: const Offset(0, 3),
                blurRadius: 5,
                spreadRadius: 2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientInfo(Cliente cliente) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Minhas Informações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              FaIcon(FontAwesomeIcons.user),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text('Usuário: ${cliente.nome}'),
        Text('E-mail: ${cliente.email}'),
        Text('CPF: ${cliente.cpf}'),
      ],
    );
  }

  Widget _buildAddressInfo(BuildContext context, Cliente cliente) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Endereço',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => editInfo(context, cliente),
              icon: const FaIcon(FontAwesomeIcons.pen),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text('Telefone: ${(cliente.telefone != '(') ? cliente.telefone : ''}'),
        Text('Rua: ${(cliente.rua != 'null') ? cliente.rua : ''}'),
        Text('Cidade: ${(cliente.cidade != 'null') ? cliente.cidade : ''}'),
        Text('Número: ${(cliente.numero != 'null') ? cliente.numero : ''}'),
        Text('Estado: ${(cliente.estado != 'null') ? cliente.estado : ''}'),
        Text('Bairro: ${(cliente.bairro != 'null') ? cliente.bairro : ''}'),
        Text('CEP: ${(cliente.cep != 'null') ? cliente.cep : ''}'),
      ],
    );
  }

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
}

void editInfo(BuildContext context, Cliente cliente) {
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController ruaController = TextEditingController(text: (cliente.rua != 'null') ? cliente.rua : '');
  TextEditingController cidadeController = TextEditingController(text: (cliente.cidade != 'null') ? cliente.cidade : '');
  TextEditingController numeroController = TextEditingController(text: (cliente.numero != 'null') ? cliente.numero : '');
  TextEditingController estadoController = TextEditingController(text: (cliente.estado != 'null') ? cliente.estado : '');
  TextEditingController cepController = TextEditingController(text: (cliente.cep != 'null') ? cliente.cep : '');
  TextEditingController bairroController = TextEditingController(text: (cliente.bairro != 'null') ? cliente.bairro : '');
  phoneController.text = (cliente.telefone != '(') ? cliente.telefone : '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Editar Informações'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              TextFormField(
                controller: ruaController,
                decoration: const InputDecoration(labelText: 'Rua'),
              ),
              TextFormField(
                controller: bairroController,
                decoration: const InputDecoration(labelText: 'Bairro'),
              ),
              TextFormField(
                controller: cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
              TextFormField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: 'Número'),
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              TextFormField(
                controller: cepController,
                decoration: const InputDecoration(labelText: 'CEP'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              cliente.atualizarEndereco(
                telefone: phoneController.text,
                rua: ruaController.text,
                cidade: cidadeController.text,
                numero: numeroController.text,
                estado: estadoController.text,
                cep: cepController.text,
                bairro: bairroController.text,
              );
              Provider.of<GetCliente>(context, listen: false).atualizarCliente(cliente);
              Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
