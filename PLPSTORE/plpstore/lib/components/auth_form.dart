import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/pokeball_loading.dart';
import 'package:plpstore/components/validar_cpf.dart';
import 'package:plpstore/model/auth.dart';
import 'package:plpstore/model/get_clientes.dart';
import 'package:plpstore/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  ValidarCpf validarCpf = ValidarCpf();
  final _passwordController = TextEditingController();
  final _fCpfController = MaskedTextController(mask: '000.000.000-00');
  final _emailController = TextEditingController();
  final _fEmailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  bool _rememberMe = false;
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool _isLoading = false;

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
      _authMode = _isLogin() ? AuthMode.signup : AuthMode.login;
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

  Future<void> _submitPassword() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    String resposta =
        await _sendPasswordEmail(_fEmailController.text, _fCpfController.text);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperação de Senha'),
          content: Text(resposta),
          actions: [
            TextButton(
              onPressed: () {
                _fCpfController.clear();
                _fEmailController.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await _savePreferences();
    final navigator = Navigator.of(context);
    Auth auth = Provider.of<Auth>(context, listen: false);
    final GetCliente cliente = Provider.of<GetCliente>(context, listen: false);
    int resposta;
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin()) {
        resposta =
            await auth.login(_emailController.text, _passwordController.text);
        if (resposta == 1) {
          cliente.pegaClients(_cpfController.text);
          String level = auth.getLevel();
          navigator.pushReplacementNamed(
              level == 'Cliente' ? AppRoutes.home : AppRoutes.admHome);
        } else {
          _showErrorDialog('Ocorreu um erro: ${auth.getMensagem()}');
        }
      } else {
        resposta = await auth.signup(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _cpfController.text,
        );
        if (resposta == 1) {
          _showSuccessDialog();
        } else {
          _showErrorDialog('Ocorreu um erro: ${auth.getMensagem()}');
        }
      }
    } catch (error) {
      _showErrorDialog('Erro ao processar sua solicitação.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _sendPasswordEmail(String email, String cpf) async {
    Auth verificar = Auth();
    String resposta = await verificar.recuperarSenha(email, cpf);
    return resposta;
  }

  void _passwordRecover(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar senha!'),
          content: Form(
            key: _passwordFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Informe seu e-mail'),
                TextFormField(
                  controller: _fEmailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(FontAwesomeIcons.at,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minHeight: 1, minWidth: 38),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (_email) {
                    final email = _email ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const Text('Informe seu CPF'),
                TextFormField(
                  controller: _fCpfController,
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(FontAwesomeIcons.idCardClip,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minHeight: 1, minWidth: 38),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _fCpfController.clear();
                _fEmailController.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            ElevatedButton(
              onPressed: _submitPassword,
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? PokeballLoading()
        : Container(
            padding: const EdgeInsets.all(16),
            width: deviceSize.width * 0.85,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    icon: FontAwesomeIcons.at,
                    keyboardType: TextInputType.emailAddress,
                    validator: (_email) {
                      final email = _email ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    icon: FontAwesomeIcons.lock,
                    obscureText: _isObscure,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: FaIcon(
                        _isObscure
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                      ),
                    ),
                    validator: (_password) {
                      final password = _password ?? '';
                      if (password.isEmpty || password.length < 4) {
                        return 'Informe uma senha válida.';
                      }
                      return null;
                    },
                  ),
                  if (_isLogin())
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        Text('Manter Conectado'),
                      ],
                    ),
                  if (_isSignup())
                    _buildTextField(
                      controller: _passwordConfirmController,
                      label: 'Confirmar Senha',
                      icon: FontAwesomeIcons.lock,
                      obscureText: _isObscureConfirm,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscureConfirm = !_isObscureConfirm;
                          });
                        },
                        icon: FaIcon(
                          _isObscureConfirm
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                        ),
                      ),
                      validator: (_password) {
                        final password = _password ?? '';
                        if (password != _passwordController.text) {
                          return 'Senhas não conferem.';
                        }
                        return null;
                      },
                    ),
                  if (_isSignup())
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nome Completo',
                      icon: FontAwesomeIcons.signature,
                      validator: (_nome) {
                        final nome = _nome ?? '';
                        if (nome.trim().isEmpty || nome.length < 5) {
                          return 'Informe um nome válido.';
                        }
                        return null;
                      },
                    ),
                  if (_isSignup())
                    _buildTextField(
                      controller: _cpfController,
                      label: 'CPF',
                      icon: FontAwesomeIcons.idCardClip,
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
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                      ),
                      child: Text(
                        _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _passwordRecover(context),
                        child: Text('Recuperar Senha?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            )),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(_isLogin() ? 'CADASTRAR' : 'LOGIN',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        )),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(icon, color: Theme.of(context).colorScheme.secondary),
          ),
          prefixIconConstraints:
              const BoxConstraints(minHeight: 1, minWidth: 38),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
