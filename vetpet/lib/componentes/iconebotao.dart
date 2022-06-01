
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constantes/constantes.dart';

class IconeBotao  {
  const IconeBotao({ required this.icone, required this.rotulo}) ;
  final IconData icone;
  final String rotulo;

  Widget bt (Function() func) {
    // TODO: implement build
    return SizedBox.fromSize(size: const Size(56, 56),
      child: ClipOval(
        child: Material(
          color: COLOR_ORANGE_BT,
          child: InkWell(
            splashColor: Colors.yellow,
            onTap: () {
              func.call();
              },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icone,color: COLOR_WHITE), // <-- Icon
                Text(rotulo,style: texto_white,), // <-- Text
              ],
            ),
          ),
        ),
      ),);
  }



}