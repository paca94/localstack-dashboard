import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;

  const CardButton({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
