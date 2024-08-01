import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/model/product.dart';

class EditDetailProductPage extends StatefulWidget {
  final Product? produto;
  final int? edit;
  final int? total;
  const EditDetailProductPage({super.key, this.produto, this.edit, this.total});

  @override
  State<EditDetailProductPage> createState() => _EditDetailProductPageState();
}

class _EditDetailProductPageState extends State<EditDetailProductPage> {
  final List<String> colecao = [
    'Produtos Fechados',
    'Mascaras do Crepúsculo',
    'Forças Temporais',
    'Destinos de Paldea',
    'Fenda Paradoxal',
    'Escarlate e Violeta 151',
  ];
  final List<String> subCategoria = [
    'Energia',
    'Pokemon',
    'Treinador',
  ];
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
  late TextEditingController _cCategoria;
  late TextEditingController _cSubCategoria;
  late TextEditingController _cNome;
  late TextEditingController _cNomeUrl;
  late TextEditingController _cDescricao;
  late TextEditingController _cDescricaoLonga;
  late TextEditingController _cValor;
  late TextEditingController _cImagem;
  late TextEditingController _cEstoque;
  late TextEditingController _cTipoEnvio;
  late TextEditingController _cPalavras;
  late TextEditingController _cAtivo;
  late TextEditingController _cPeso;
  late TextEditingController _cLargura;
  late TextEditingController _cAltura;
  late TextEditingController _cComprimento;
  late TextEditingController _cModelo;
  late TextEditingController _cValorFrete;
  late TextEditingController _cPromocao;
  late TextEditingController _cCategoriaNome;
  late TextEditingController _cSubCategoriaNome;
  late TextEditingController _cLink;

  @override
  void initState() {
    super.initState();
    // 1 editar
    // 0 para adicionar novo produto
    if (widget.edit == 1) {
      isRegister = false;
      _cCategoria = TextEditingController(text: widget.produto!.categoria);
      _cSubCategoria =
          TextEditingController(text: widget.produto!.subCategoria);
      _cNome = TextEditingController(text: widget.produto!.nome);
      _cNomeUrl = TextEditingController(text: widget.produto!.nomeUrl);
      _cDescricao = TextEditingController(text: widget.produto!.descricao);
      _cDescricaoLonga =
          TextEditingController(text: widget.produto!.descricaoLonga);
      _cValor = TextEditingController(text: widget.produto!.valor);
      _cImagem = TextEditingController(text: widget.produto!.imagem);
      _cEstoque = TextEditingController(text: widget.produto!.estoque);
      _cTipoEnvio = TextEditingController(text: widget.produto!.tipoEnvio);
      _cPalavras = TextEditingController(text: widget.produto!.palavras);
      _cAtivo = TextEditingController(text: widget.produto!.ativo);
      _cPeso = TextEditingController(text: widget.produto!.peso);
      _cLargura = TextEditingController(text: widget.produto!.largura);
      _cAltura = TextEditingController(text: widget.produto!.altura);
      _cComprimento = TextEditingController(text: widget.produto!.comprimento);
      _cModelo = TextEditingController(text: widget.produto!.modelo);
      _cValorFrete = TextEditingController(text: widget.produto!.valorFrete);
      _cPromocao = TextEditingController(text: widget.produto!.promocao);
      _cCategoriaNome =
          TextEditingController(text: widget.produto!.categoriaNome);
      _cSubCategoriaNome =
          TextEditingController(text: widget.produto!.subCategoriaNome);
      _cLink = TextEditingController(text: widget.produto!.link);
    } else {
      isRegister = true;
      _cCategoria = TextEditingController(text: '');
      _cSubCategoria = TextEditingController(text: '');
      _cNome = TextEditingController(text: '');
      _cNomeUrl = TextEditingController(text: '');
      _cDescricao = TextEditingController(text: '');
      _cDescricaoLonga = TextEditingController(text: '');
      _cValor = TextEditingController(text: '');
      _cImagem = TextEditingController(text: '');
      _cEstoque = TextEditingController(text: '');
      _cTipoEnvio = TextEditingController(text: '');
      _cPalavras = TextEditingController(text: '');
      _cAtivo = TextEditingController(text: '');
      _cPeso = TextEditingController(text: '');
      _cLargura = TextEditingController(text: '');
      _cAltura = TextEditingController(text: '');
      _cComprimento = TextEditingController(text: '');
      _cModelo = TextEditingController(text: '');
      _cValorFrete = TextEditingController(text: '');
      _cPromocao = TextEditingController(text: '');
      _cCategoriaNome = TextEditingController(text: '');
      _cSubCategoriaNome = TextEditingController(text: '');
      _cLink = TextEditingController(text: '');
    }
  }

  @override
  void dispose() {
    _cCategoria.dispose();
    _cSubCategoria.dispose();
    _cNome.dispose();
    _cNomeUrl.dispose();
    _cDescricao.dispose();
    _cDescricaoLonga.dispose();
    _cValor.dispose();
    _cImagem.dispose();
    _cEstoque.dispose();
    _cTipoEnvio.dispose();
    _cPalavras.dispose();
    _cAtivo.dispose();
    _cPeso.dispose();
    _cLargura.dispose();
    _cAltura.dispose();
    _cComprimento.dispose();
    _cModelo.dispose();
    _cValorFrete.dispose();
    _cPromocao.dispose();
    _cCategoriaNome.dispose();
    _cSubCategoriaNome.dispose();
    _cLink.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!isRegister ? widget.produto!.descricao : 'Novo Produto',
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            _confirmCancel();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                showLoadingDialog(context);
                Future.delayed(const Duration(seconds: 7), () {
                  // Fecha o diálogo de carregamento
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
              icon: const FaIcon(FontAwesomeIcons.floppyDisk)),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            !isRegister
                ? Text('Total de Produtos : ${widget.total.toString()}')
                : Text('Produto nº : ${(widget.total! + 1).toString()}'),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextField(_cNome, 'Nome'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Coleção'),
                      DropdownButton<String>(
                        hint: const Text('Selecione uma Coleção'),
                        value: _cCategoriaNome.text.isNotEmpty
                            ? _cCategoriaNome.text
                            : null,
                        items: colecao.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _cCategoriaNome.text = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Categoria'),
                      DropdownButton<String>(
                        hint: const Text('Selecione uma Categoria'),
                        value: _cSubCategoriaNome.text.isNotEmpty
                            ? _cSubCategoriaNome.text
                            : null,
                        items: subCategoria.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _cSubCategoriaNome.text = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  _buildTextField(_cDescricao, 'Descrição Curta'),
                  _buildTextField(_cDescricaoLonga, 'Descrição Longa', line: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_cValor, 'Valor(R\$)'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_cEstoque, 'Estoque'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_cPalavras, 'Palavra Chave'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Ativo',
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(width: 10),
                            DropdownButton(
                              value:
                                  _cAtivo.text.isNotEmpty ? _cAtivo.text : null,
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
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Envio',
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(width: 10),
                            DropdownButton(
                              value: _cTipoEnvio.text.isNotEmpty
                                  ? _cTipoEnvio.text
                                  : null,
                              items: tipoEnvio.entries
                                  .map((MapEntry<String, String> entry) {
                                // quando voce descobrir, replicar em categoria e sub categoria
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
                      ),
                    ],
                  ),
                  _buildTextField(_cPeso, 'Peso (em KG - Ex: 200g seria 0.2)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: _buildTextField(_cLargura, 'Largura (cm)')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildTextField(_cAltura, 'Altura')),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField(_cComprimento, 'Comprimento')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_cLink, 'Link'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_cModelo, 'Modelo'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_cValorFrete, 'Valor do Frete'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: _cImagem.text.isNotEmpty
                            ? Image.network(
                                'https://plpstore.com.br/img/produtos/${widget.produto!.imagem}')
                            : Image.asset('assets/img/tcg_card_back.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          controller: _cImagem,
                          decoration: const InputDecoration(
                            labelText: 'Imagem',
                          ),
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //implementar abertura de camera ou galeria e substituir o _cImagem para a nova imagem
                      },
                      child: const Text('Selecionar Imagem'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel() async {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar"),
          content: const Text("As alterações não serão salvas, confirmar?"),
          actions: [
            TextButton(
              onPressed: () {
                _cancel(); // Confirma e fecha o diálogo
              },
              child: const Text("Sim"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela e fecha o diálogo
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _cancel() {
    Navigator.of(context).pop();
    Navigator.pop(context);
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede o usuário de fechar o diálogo
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PokeballLoading(),
              SizedBox(height: 16),
              Text('Salvando'),
            ],
          ),
        );
      },
    );
  }
}
