
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../componentes/cardpetselecionado.dart';
import '../../componentes/iconebotao.dart';
import '../../constantes/constantes.dart';
import '../../controller/avisocontroller.dart';

import 'package:get/get.dart';
import '../../model/aviso.dart';





class ListaAvisosPet extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AvisoController avisocontroller =  Get.put(AvisoController());

  ListaAvisosPet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    avisocontroller.buscaAvisos();
    return
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(actions: [const IconeBotao( icone: Icons.add , rotulo: textoIncluir).bt(  () {
          avisocontroller.idaviso.value = 0;
          avisocontroller.limparCamposTela();
          Get.toNamed('/cadastroAviso');
        }),const SizedBox(width: 8)],
          title: const Text("Lista Avisos", semanticsLabel: "Lista Avisos",),
          backgroundColor: COLOR_ORANGE,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[CardPetSelecionado(),
              GetX<AvisoController>(
                builder: (avisocontroller) =>
                    Expanded(flex: 3, child: _listaAvisos(avisocontroller)),
              ),
              //Obx((){  return _listaPets(petController);}),
              // Row(children: [petAnterior(),petProximo(),petEditar(), incluirPet() ,],),
            ],
          ),
        ),
      );
  }

  Widget _listaAvisos(AvisoController avisocontroller) {
    if (avisocontroller.avisos.isNotEmpty) {
      return SizedBox(
          height: 130.0,
          //width: 350,
          child: ListView.builder(
              reverse: false,
              itemBuilder: (context, index) {
                final Aviso aviso = avisocontroller.avisos.value.elementAt(index);
                return Card(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                    trailing: const IconeBotao( icone: Icons.edit , rotulo: textoBotaoEditar).bt(  () {
                      avisocontroller.idaviso.value = aviso.id;
                      print("Id aviso Edit ${aviso.id}");
                      Get.toNamed('/cadastroAviso');
                    }),
                          title: Text("Aviso:" +
                              aviso.nomeaviso),
                          subtitle: Text("Data do Aviso:" +
                              aviso.datavencimento.toString() +
                              "\nData de Retorno: " +
                              aviso.datacadastro.toString()),
                          isThreeLine: true,
                          onLongPress: () async {
                         /*   await Get.to(() => CadastroPet(),
                                arguments: [{'idpet': pet.id}]);*/
                          },
                          onTap: () {

                          },
                        ),
                      ],
                    ));
              },
              itemCount: avisocontroller.avisos.length)
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Nenhum Aviso Cadastrado.',
            ),
          ],
        ),
      );
    }
  }
}