import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BottonNavigator extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottonNavigator(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      onTap: (index) {
        onTap(index);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house), label: 'Home'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.grip), label: 'Coleções'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.box), label: 'Produtos'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.tag), label: 'Promoção'),
      ],
      currentIndex: currentIndex,
      elevation: 8.0,
      showUnselectedLabels: true,
      unselectedLabelStyle: const TextStyle(color: Color.fromRGBO(217, 232, 255, 100)),
      backgroundColor: const Color.fromRGBO(217, 232, 255, 100),
      selectedItemColor: const Color.fromARGB(255, 9, 47, 105),
      unselectedItemColor: Colors.blue,
    );
  }
}
