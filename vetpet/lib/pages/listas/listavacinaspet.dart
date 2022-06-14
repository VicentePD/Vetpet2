
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../componentes/cardpetselecionado.dart';
import '../../componentes/iconebotao.dart';
import '../../constantes/constantes.dart';
import '../../controller/vacinacontroller.dart';
import 'package:get/get.dart';
import '../../model/vacina.dart';




class ListaVacinasPet extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VacinaController vacinacontroller =  Get.put(VacinaController());

  ListaVacinasPet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    vacinacontroller.buscaVacinas();
    return
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(actions: [const IconeBotao( icone: Icons.add , rotulo: textoIncluir).bt(  () {
          vacinacontroller.idvacina.value = 0;
          Get.toNamed('/cadastroVacina');
        }),const SizedBox(width: 8),],
          title: const Text("Lista Vacinas", semanticsLabel: "Lista Vacinas",),
          backgroundColor: COLOR_ORANGE,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[CardPetSelecionado(),
              GetX<VacinaController>(
                builder: (vacinacontroller) =>
                    Expanded(flex: 3, child: _listaVacinas(vacinacontroller)),
              ),
              //Obx((){  return _listaPets(petController);}),
              // Row(children: [petAnterior(),petProximo(),petEditar(), incluirPet() ,],),
            ],
          ),
        ),
      );
  }

  Widget _listaVacinas(VacinaController vacinacontroller) {
    if (vacinacontroller.vacinas.isNotEmpty) {
      return SizedBox(
          height: 130.0,
          //width: 350,
          child: ListView.builder(
              reverse: false,
              itemBuilder: (context, index) {
                final Vacina vacina = vacinacontroller.vacinas.value.elementAt(index);
                return Card(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                    trailing: const IconeBotao( icone: Icons.edit , rotulo: textoBotaoEditar).bt(  () {
                      vacinacontroller.idvacina.value = vacina.id;
                      print("Id vacina Edit ${vacina.id}");
                      Get.toNamed('/cadastroVacina');
                    }),
                          title: Text("Vacina:" +
                              vacina.nome_vacina),
                          subtitle: Text("Data Aplicação:" +
                              vacina.dataaplicacao.toString() +
                              "\nData de Retorno: " +
                              vacina.dataretorno.toString()),
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
              itemCount: vacinacontroller.vacinas.length)
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Nenhuma Vacina Cadastrada.',
            ),
          ],
        ),
      );
    }
  }
}