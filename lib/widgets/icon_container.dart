import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({super.key, required this.icon});
  final icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Icon(
        icon,
      ),
    );
  }
}
