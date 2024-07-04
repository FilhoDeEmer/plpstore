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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/img/LOGO_1.png',
                          fit: BoxFit.cover),
                    ),
                    const AuthForm(),
                    TextButton(onPressed: (){Navigator.of(context).popAndPushNamed(AppRoutes.home);}, child: const Text('Acessar a Loja', style: TextStyle(color: Colors.red),)),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.instagram, color: Colors.pink,),
                        const SizedBox(width: 5,),
                        TextButton( onPressed: (){
                          FuncaoExterna().instagram();
                        }, child: const Text('@plpstore', style: TextStyle(color: Colors.black),)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green,),
                        const SizedBox(width: 5,),
                        TextButton( onPressed: (){
                          FuncaoExterna().whatsApp();
                        }, child: const Text('(13) 9 9618-7797', style: TextStyle(color: Colors.black),)),
                      ],
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.envelope, color: Colors.black,),
                        const SizedBox(width: 5,),
                        TextButton( onPressed: (){
                          FuncaoExterna().email();
                        }, child: const Text('adm@plpstore.com.br', style: TextStyle(color: Colors.black),)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
