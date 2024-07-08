// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/validar_cpf.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  ValidarCpf validarCpf = ValidarCpf();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  
  AuthMode _authMode = AuthMode.login;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordConfirmController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso'),
        content: const Text('Usuário cadastrado com sucesso!'),
        actions: [
          TextButton(
              onPressed: () {
                _nameController.clear();
                _emailController.clear();
                _passwordController.clear();
                _cpfController.clear();
                _passwordConfirmController.clear();
                Navigator.pop(context);
                _switchAuthMode();
              },
              child: const Text('OK'))
        ],
      ),
    );
  }
  bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11) {
      return false;
    }

    if (cpf == '00000000000' ||
        cpf == '11111111111' ||
        cpf == '22222222222' ||
        cpf == '33333333333' ||
        cpf == '44444444444' ||
        cpf == '55555555555' ||
        cpf == '66666666666' ||
        cpf == '77777777777' ||
        cpf == '88888888888' ||
        cpf == '99999999999') {
      return false;
    }

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int primeiroDigito = (soma * 10) % 11;
    if (primeiroDigito == 10) {
      primeiroDigito = 0;
    }

    if (int.parse(cpf[9]) != primeiroDigito) {
      return false;
    }

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int segundoDigito = (soma * 10) % 11;
    if (segundoDigito == 10) {
      segundoDigito = 0;
    }

    if (int.parse(cpf[10]) != segundoDigito) {
      return false;
    }

    return true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final navigator = Navigator.of(context);
    Auth auth = Provider.of<Auth>(context, listen: false);
    final GetCliente cliente = Provider.of<GetCliente>(context, listen: false);
    int resposta;

    //try {
      if (_isLogin()) {
        resposta =
            await auth.login(_emailController.text, _passwordController.text);        
        if (resposta == 1) {          
          cliente.pegaClients(_cpfController.text);
          String level = auth.getLevel();
          if (level == 'Cliente') {
            navigator.pushReplacementNamed(AppRoutes.home);
          } else {
            navigator.pushReplacementNamed(AppRoutes.admHome);
          }
          return;
        } else {
          _showErrorDialog('Ocorreu um erro : ${auth.getMensagem()}');
          return;
        }
      } else {
        resposta = await auth.signup(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _cpfController.text,
        );
        if(resposta == 1) {
          _showSuccessDialog();
        }
        else{
          _showErrorDialog('Ocorreu um erro: ${auth.getMensagem()}');
        }
      }


  }

  void _sendPasswordEmail(String email) {
    // Implementar a lógica para enviar um e-mail de recuperação de senha
  }

  void _passwordRecover() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Informe um e-mail'),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: FaIcon(FontAwesomeIcons.at),
                  prefixIconConstraints: BoxConstraints(minHeight: 1, minWidth: 38),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPasswordEmail(_emailController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.85,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: FaIcon(FontAwesomeIcons.at),
                  prefixIconConstraints: BoxConstraints(minHeight: 1, minWidth: 38),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                  prefixIconConstraints: const BoxConstraints(minHeight: 1, minWidth: 38),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: FaIcon(_isObscure
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye),
                  ),
                ),
                obscureText: _isObscure,
                controller: _passwordController,
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 6) {
                    return 'Informe uma senha válida.';
                  }
                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  controller: _passwordConfirmController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                    prefixIconConstraints: const BoxConstraints(minHeight: 1, minWidth: 38),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscureConfirm = !_isObscureConfirm;
                        });
                      },
                      icon: FaIcon(_isObscureConfirm
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye),
                    ),
                  ),
                  obscureText: _isObscureConfirm,
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password != _passwordController.text) {
                      return 'Senhas não conferem.';
                    }
                    return null;
                  },
                ),
              if (_isSignup())
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: FaIcon(FontAwesomeIcons.signature),
                    prefixIconConstraints: BoxConstraints(minHeight: 1, minWidth: 38),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  validator: (_nome) {
                    final nome = _nome ?? '';
                    if (nome.trim().isEmpty || nome.length < 5) {
                      return 'Informe um nome válido.';
                    }
                    return null;
                  },
                ),
              if (_isSignup())
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    prefixIcon: FaIcon(FontAwesomeIcons.idCardClip),
                    prefixIconConstraints: BoxConstraints(minHeight: 1, minWidth: 38),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (!validarCpf.validarCPF(value)) {
                        return 'CPF inválido';
                      }
                      return null;
                    },
                ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 101, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  ),
                  child: Text(
                    _isLogin() ? 'LOGIN' : 'REGISTRAR',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(_isLogin() ? 'CADASTRAR' : 'LOGIN'),
              ),
              TextButton(
                onPressed: _passwordRecover,
                child: const Text(
                  'Recuperar Senha?',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
