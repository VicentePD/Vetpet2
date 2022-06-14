
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../help/imagemutil.dart';
import 'avatarpet.dart';

import '../../model/globals.dart' as globals;


class CardPetSelecionado extends StatelessWidget {

  @override
  Widget  build(BuildContext context){
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: AvatarPet( ImageUtility.imageFromBase64String( globals.fotopetsel ).image)  ,
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
