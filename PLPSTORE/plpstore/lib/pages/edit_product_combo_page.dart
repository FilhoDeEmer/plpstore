import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/combo_add_product.dart';
import 'package:plpstore/components/combo_list_product.dart';

class EditComboProductPage extends StatefulWidget {
  const EditComboProductPage({super.key});

  @override
  State<EditComboProductPage> createState() => _EditComboProductPageState();
}

bool isList = true;

class _EditComboProductPageState extends State<EditComboProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Nome do Combo', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    isList = !isList;
                  });
                },
                icon: isList
                    ? const FaIcon(FontAwesomeIcons.plus)
                    : const FaIcon(FontAwesomeIcons.list)),
          )
        ],
      ),
      body: isList ? ComboListProduct() : ComboAddProduct(),
    );
  }
}
