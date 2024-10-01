import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;
  final Color? textColor; 

  const Badgee({
    Key? key,
    required this.child,
    required this.value,
    this.color,
    this.textColor, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter, 
      children: [
        child,
        if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) > 0)
          Positioned(
            top: -5,
            right: -5, 
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
              constraints: const BoxConstraints(
                minHeight: 16,
                minWidth: 16,
              ),
              child: Center(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor ?? Colors.white, 
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
