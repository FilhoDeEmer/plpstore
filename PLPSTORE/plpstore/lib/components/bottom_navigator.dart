import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plpstore/components/badgee.dart'; // Certifique-se de que este caminho está correto

class BottomNavigator extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int cartItemCount;

  const BottomNavigator({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.cartItemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).appBarTheme.backgroundColor!,
            Theme.of(context).appBarTheme.foregroundColor!,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: BottomNavigationBar(
        onTap: onTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.grip),
            label: 'Coleções',
          ),
          BottomNavigationBarItem(
            icon: Badgee(
              child: FaIcon(FontAwesomeIcons.cartShopping),
              value: cartItemCount.toString(),
              color: Color.fromRGBO(212, 133, 55, 1),
            ),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.circleUser),
            label: 'Perfil',
          ),
        ],
        currentIndex: currentIndex,
        elevation: 0.0,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1),
        ),
        backgroundColor: Colors.transparent,
        unselectedItemColor: Color.fromARGB(255, 153, 143, 0),
        selectedItemColor: Color.fromARGB(255, 89, 85, 0),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
