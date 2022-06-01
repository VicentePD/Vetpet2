
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constantes/constantes.dart';
import '../../controller/petcontroller.dart';
import '../../help/imagemutil.dart';
import '../../model/globals.dart' as globals;
import 'package:get/get.dart';

import '../../model/pet.dart';
import '../cadastros/cadastropet.dart';



class ListaPetsCadastrados extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PetController petController = Get.put(PetController());

  ListaPetsCadastrados({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text("Lista Pet", semanticsLabel: "Lista Pet",),
          backgroundColor: COLOR_ORANGE,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              GetX<PetController>(
                builder: (petController) =>
                    Expanded(flex: 3, child: _listaPets(petController)),
              ),
              //Obx((){  return _listaPets(petController);}),
              // Row(children: [petAnterior(),petProximo(),petEditar(), incluirPet() ,],),
            ],
          ),
        ),
      );
  }

  Widget _listaPets(petController) {
    if (petController.pets.isNotEmpty) {
      return SizedBox(
          height: 130.0,
          //width: 350,
          child: ListView.builder(
              reverse: false,
              itemBuilder: (context, index) {
                final Pet pet = petController.pets.value.elementAt(index);
                return Card(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
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
                                    pet.foto)),
                          ),
                          title: Text("Nome:" +
                              pet.nome.toString()),
                          subtitle: Text("Data Nascimento:" +
                              pet.datanascimento.toString() +
                              "\nTipo: " +
                              pet.tipo.toString()),
                          isThreeLine: true,

                          tileColor: globals.idpetsel == pet.id
                              ? Colors.orange[100]
                              : null,

                          onLongPress: () async {
                            await Get.to(() => CadastroPet(),
                                arguments: [{'idpet': pet.id}]);
                          },
                          onTap: () {
                            petController.selecionarPet(pet.id);
                            petController.update();
                            Get.forceAppUpdate();

                          },
                        ),
                      ],
                    ));
              },
              itemCount: petController.pets.length)
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Nenum Pet Cadastrado.',
            ),
          ],
        ),
      );
    }
  }
}