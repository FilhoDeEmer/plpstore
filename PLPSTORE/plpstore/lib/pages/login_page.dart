import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/auth_form.dart';
import 'package:plpstore/components/funcao_externas.dart';
import 'package:plpstore/utils/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(217, 232, 255, 1),
                  Color.fromRGBO(172, 205, 255, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network("https://plpstore.com.br/img/logo.png",width: 280,
                      height: 280,),
                      
                      
                    ),
                    const AuthForm(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(AppRoutes.home);
                      },
                      child: const Text(
                        'Acessar a Loja',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    _buildContactRow(
                      icon: FontAwesomeIcons.instagram,
                      iconColor: Colors.pink,
                      text: '@plpstore_',
                      onPressed: () => FuncaoExterna().instagram(),
                    ),
                    _buildContactRow(
                      icon: FontAwesomeIcons.whatsapp,
                      iconColor: Colors.green,
                      text: '(13) 9 9618-7797',
                      onPressed: () => FuncaoExterna().whatsApp(),
                    ),
                    _buildContactRow(
                      icon: FontAwesomeIcons.envelope,
                      iconColor: Colors.black,
                      text: 'adm@plpstore.com.br',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(icon, color: iconColor),
        const SizedBox(width: 5),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
