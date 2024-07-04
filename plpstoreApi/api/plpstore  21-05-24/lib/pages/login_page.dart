import 'package:flutter/material.dart';
import 'package:plpstore/components/auth_form.dart';

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
                  Color.fromRGBO(106, 156, 223, 0.494),
                  Color.fromRGBO(63, 22, 212, 0.952),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const Center(
            child:  SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PLPStore',
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.blue,
                      ),
                    ),
                    AuthForm(),
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
