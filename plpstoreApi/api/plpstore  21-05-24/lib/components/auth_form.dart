import 'package:flutter/material.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _cpfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  AuthMode _authMode = AuthMode.Login;

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      _authMode = _isLogin() ? AuthMode.Signup : AuthMode.Login;
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    final BuildContext context = this.context;

    if (!isValid) {
      return;
    }

    void showErrorDialog(String msg) {
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

    Auth auth = Provider.of<Auth>(context, listen: false);
    int resposta = 0;

    try {
      if (_isLogin()) {
        resposta = await auth.login(_emailController.text, _passwordController.text);
        if (resposta == 1) {
          Navigator.of(context).pushNamed(AppRoutes.home);
          return;
        } else {
          showErrorDialog('Ocorreu um erro: Usuário não cadastrado ou senha inválida');
          return;
        }
      } else {
        resposta = await auth.signup(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _cpfController.text,
        );
      }
    } catch (error) {
      showErrorDialog('Ocorreu um erro: $error');
      return;
    }

    if (_isSignup() && resposta == 1) {
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
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      showErrorDialog('Usuário já cadastrado!');
    }
  }

  void _sendPasswordEmail(String email) {
    // Implementar lógica para envio de e-mail de recuperação de senha
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                obscureText: _isObscure,
                controller: _passwordController,
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  controller: _passwordConfirmController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscureConfirm = !_isObscureConfirm;
                        });
                      },
                      icon: Icon(
                        _isObscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: _isObscureConfirm,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return 'Senhas não conferem';
                          }
                          return null;
                        },
                ),
              if (_isSignup())
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  keyboardType: TextInputType.emailAddress,
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
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                  validator: (_cpf) {
                    final cpf = _cpf ?? '';
                    if (cpf.isEmpty || cpf.length < 11) {
                      return 'Informe um CPF válido.';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                ),
                child: Text(_isLogin() ? 'LOGIN' : 'REGISTRAR'),
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
