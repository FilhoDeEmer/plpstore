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
    return BottomNavigationBar(
      onTap: (index) {
        onTap(index);
      },
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
      elevation: 8.0,
      showUnselectedLabels: true,
      unselectedLabelStyle: const TextStyle(
        color: Color.fromRGBO(217, 232, 255, 100),
      ),
      backgroundColor: Color.fromRGBO(252, 246, 212, 0.698),
      unselectedItemColor: Color.fromRGBO(212, 175, 55, 1),
      selectedItemColor: Color.fromRGBO(101, 84, 26, 1),
      type: BottomNavigationBarType.fixed,
    );
  }
}
