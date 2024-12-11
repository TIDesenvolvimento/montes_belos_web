import 'package:flutter/material.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 200),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 25 : 0,
      decoration: BoxDecoration(
          color: Configuracao().COR_SECUNDARIA,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
