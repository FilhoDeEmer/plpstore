import 'package:flutter/material.dart';

class ComboEdit extends StatefulWidget {
  final int edit;
  final String? produto;
  const ComboEdit({super.key, required this.edit, this.produto});

  @override
  State<ComboEdit> createState() => _ComboEditState();
}

class _ComboEditState extends State<ComboEdit> {
  final Map<String, String> tipoEnvio = {
    '1': 'Correios',
    '2': 'Digital',
    '3': 'Sem Frete',
    '4': 'Valor Fixo',
  };

  final List<String> ativo = [
    'Sim',
    'Não',
  ];

  late bool isRegister;
  late TextEditingController _cNome;
  late TextEditingController _cDescricao;
  late TextEditingController _cDescricaoLonga;
  late TextEditingController _cValor;
  late TextEditingController _cImagem;
  late TextEditingController _cTipoEnvio;
  late TextEditingController _cPalavras;
  late TextEditingController _cAtivo;
  late TextEditingController _cPeso;
  late TextEditingController _cLargura;
  late TextEditingController _cAltura;
  late TextEditingController _cComprimento;
  late TextEditingController _cValorFrete;
  late TextEditingController _cLink;

  @override
  void initState() {
    super.initState();
    // 1 editar
    // 0 para adicionar novo produto
    // if (widget.edit == 1) {
    //   isRegister = false;
    //   _cNome = TextEditingController(text: widget.produto!.nome);
    //   _cDescricao = TextEditingController(text: widget.produto!.descricao);
    //   _cDescricaoLonga =
    //       TextEditingController(text: widget.produto!.descricaoLonga);
    //   _cValor = TextEditingController(text: widget.produto!.valor);
    //   _cImagem = TextEditingController(text: widget.produto!.imagem);
    //   _cTipoEnvio = TextEditingController(text: widget.produto!.tipoEnvio);
    //   _cPalavras = TextEditingController(text: widget.produto!.palavras);
    //   _cAtivo = TextEditingController(text: widget.produto!.ativo);
    //   _cPeso = TextEditingController(text: widget.produto!.peso);
    //   _cLargura = TextEditingController(text: widget.produto!.largura);
    //   _cAltura = TextEditingController(text: widget.produto!.altura);
    //   _cComprimento = TextEditingController(text: widget.produto!.comprimento);
    //   _cValorFrete = TextEditingController(text: widget.produto!.valorFrete);
    //   _cLink = TextEditingController(text: widget.produto!.link);
    // } else {
    isRegister = true;
    _cNome = TextEditingController(text: '');
    _cDescricao = TextEditingController(text: '');
    _cDescricaoLonga = TextEditingController(text: '');
    _cValor = TextEditingController(text: '');
    _cImagem = TextEditingController(text: '');
    _cTipoEnvio = TextEditingController(text: '');
    _cPalavras = TextEditingController(text: '');
    _cAtivo = TextEditingController(text: '');
    _cPeso = TextEditingController(text: '');
    _cLargura = TextEditingController(text: '');
    _cAltura = TextEditingController(text: '');
    _cComprimento = TextEditingController(text: '');
    _cValorFrete = TextEditingController(text: '');
    _cLink = TextEditingController(text: '');
    // }
  }

  @override
  void dispose() {
    _cNome.dispose();
    _cDescricao.dispose();
    _cDescricaoLonga.dispose();
    _cValor.dispose();
    _cImagem.dispose();
    _cTipoEnvio.dispose();
    _cPalavras.dispose();
    _cAtivo.dispose();
    _cPeso.dispose();
    _cLargura.dispose();
    _cAltura.dispose();
    _cComprimento.dispose();
    _cValorFrete.dispose();
    _cLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nome do combo'),
      backgroundColor: Colors.white,
      content: SizedBox(
        width: 1000,
        height: 1000,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTextField(_cNome, 'Nome'),
              _buildTextField(_cValor, 'Valor'),
              Row(
                children: [
                  const Text('Ativo: '),
                  const SizedBox(
                width: 5,
              ),
              DropdownButton(
                value: _cAtivo.text.isNotEmpty ? _cAtivo.text : null,
                items: ativo.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _cAtivo.text = newValue!;
                  });
                },
              ),
                ],
              ),
              Row(
                children: [
                  const Text('Envio: '),
                  const SizedBox(
                width: 5,
              ),
              DropdownButton(
                value:
                    _cTipoEnvio.text.isNotEmpty ? _cTipoEnvio.text : null,
                items:
                    tipoEnvio.entries.map((MapEntry<String, String> entry) {
                  
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _cTipoEnvio.text = newValue!;
                  });
                },
              ),
                ],
              ),
              
              _buildTextField(_cDescricao, 'Descricão'),
              _buildTextField(_cDescricaoLonga, 'Descricão Longa'),
              _buildTextField(_cPalavras, 'Palavras Chave'),
              _buildTextField(_cPeso, 'Peso'),
              _buildTextField(_cLargura, 'Largura'),
              _buildTextField(_cAltura, 'Altura'),
              _buildTextField(_cComprimento, 'Comprimento'),
              _buildTextField(_cLink, 'Link'),
              _buildTextField(_cValorFrete, 'Valor Frete'),
              _buildTextField(_cImagem, 'Imagem'),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: () {}, child: const Text('Selecionar Imagem')),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Adicionar a ação de salvar
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Salvar', style: TextStyle(color: Colors.white),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(TextEditingController controller, String label,
    {int? line = 1}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
    ),
    maxLines: line,
  );
}
