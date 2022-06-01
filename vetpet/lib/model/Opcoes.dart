import 'package:flutter/cupertino.dart';

@immutable
class Opcoes {
  const Opcoes({
    required this.descOpcoes,
  });

  final String descOpcoes;

  @override
  String toString() {
    return '$descOpcoes';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Opcoes && other.descOpcoes == descOpcoes ;
  }

//@override
//int get hashCode => hashValues(name );
}