
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constantes/constantes.dart';
import '../help/imagemutil.dart';
import 'iconebotao.dart';
import '../../model/globals.dart' as globals;
import 'package:get/get.dart';

class CardPetSelecionado extends StatelessWidget {

  @override
  Widget  build(BuildContext context){
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xffFDCF09),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: ImageUtility.imageFromBase64String(
                        globals.fotopetsel)),
              ),
              title: Text("Nome:" + globals.nomepetsel),
              subtitle: Text("Data Nascimento:" +
                  globals.datanascimentopet ),
              isThreeLine: true,

              tileColor:  Colors.orange[100],
              onLongPress: () async {
              },
              onTap: () {
              },
            ),
          ],
        ));
  }
}
