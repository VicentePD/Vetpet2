import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../componentes/iconebotao.dart';
import '../constantes/constantes.dart';
import '../controller/petcontroller.dart';
import 'package:get/get.dart';
import '../help/imagemutil.dart';
import '../model/globals.dart' as globals;
import 'cadastros/cadastropet.dart';
import 'drawerpage.dart';

class ListaPetHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PetController petController = Get.put(PetController());

  ListaPetHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        title: const Text(
          "Lista Pet",
          semanticsLabel: "Lista Pet",
        ),
        backgroundColor: COLOR_ORANGE,
      ),
      drawer: DrawerPage().buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Informações do PEt
            Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 8, color: Color.fromRGBO(
                      231, 147, 19, 0.74)),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                margin: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 15),
                        Text(textoPetsCadastrados,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    GetX<PetController>(
                      builder: (petController) => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              "Pet ${petController.indexLista.value + 1} de ${petController.pets.value.length}"),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                    GetX<PetController>(
                      builder: (petController) => cardpet(petController),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 5),
                        petAnterior(),
                        petEditar(),
                        incluirPet(),
                        petlistar(),
                        petProximo(),
                        const SizedBox(width: 5)
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                )),
            const SizedBox(height: 5),
            // Dados Vacina
            Container(
            decoration: BoxDecoration(
            border: Border.all(width: 8, color: Color.fromRGBO(
            231, 147, 19, 0.74)),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            margin: const EdgeInsets.all(1),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(width: 15),
                  Text(textoVainasCadastradas,
                      style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Obx(() {
                return cardvacina(petController);
              }), const SizedBox(height: 5),
             ])),

            const SizedBox(height: 5),

    Container(
    decoration: BoxDecoration(
    border: Border.all(width: 8, color: Color.fromRGBO(
    231, 147, 19, 0.74)),
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    margin: const EdgeInsets.all(1),
    child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SizedBox(width: 15),
          Text(textoAviososCadastrados,
              style:
              TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 5),
            Obx(() {
              return cardaviso(petController);
            }),])),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    petController.refreshPage();
    return Future<void>.delayed(const Duration(seconds: 3));
  }

  incluirPet() {
    return const IconeBotao(icone: Icons.add, rotulo: "Incluir").bt(() => {
          Get.toNamed('/cadastroPet', arguments: [
            {'idpet': '0'}
          ])
        });
  }

  Widget petAnterior() {
    return const IconeBotao(icone: Icons.arrow_back, rotulo: "Ant.")
        .bt(() => {petController.navegaListPet(-1)});
  }

  Widget petlistar() {
    return const IconeBotao(icone: Icons.list_alt, rotulo: "List.").bt(() {
      Get.toNamed('/listarPet');
      petController.update();
    });
  }

  Widget petProximo() {
    return const IconeBotao(icone: Icons.arrow_forward, rotulo: "Prox.")
        .bt(() => {petController.navegaListPet(1)});
  }

  Widget petEditar() {
    return const IconeBotao(icone: Icons.edit, rotulo: "Edit.").bt(() => {
          Get.toNamed('/cadastroPet', arguments: [
            {'idpet': '${petController.pet.value.id}'}
          ])
        });
  }

  Widget cardpet(PetController petController) {
    if (globals.idpetsel != petController.pet.value.id) {
      globals.idpetsel = petController.pet.value.id;
      globals.nomepetsel = petController.pet.value.nome;
      globals.fotopetsel = petController.pet.value.foto;
      globals.datanascimentopet = petController.pet.value.datanascimento;
      PetController().selecionarPet(petController.pet.value.id);
      PetController().update();
      // vacinaController.buscaVacinas();
    }
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
                    petController.pet.value.foto)),
          ),
          title: Text("Nome:" + petController.pet.value.nome.toString()),
          subtitle: Text("Data Nascimento:" +
              petController.pet.value.datanascimento.toString() +
              "\nTipo: " +
              petController.pet.value.tipo.toString()),
          isThreeLine: true,

          tileColor: globals.idpetsel == petController.pet.value.id
              ? Colors.orange[100]
              : null,
          // selected: selecionado,

          onLongPress: () async {
            await Get.to(() => CadastroPet(), arguments: [
              {'idpet': petController.pet.value.id}
            ]);
          },
          onTap: () {},
        ),
      ],
    ));
  }

  Widget cardvacina(PetController petController) {
    return Card(
        shadowColor: Colors.orange,
        elevation: 10.0,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            ListTile(
              title: Text("Vacina:" +
                  petController.vacina.value.nome_vacina.toString()),
              subtitle: Text("Data Aplicação:" +
                  petController.vacina.value.dataaplicacao.toString() +
                  "\nData Retorno: " +
                  petController.vacina.value.dataretorno.toString() +
                  "\n\nVacina ${(petController.indexVacina.value + 1)} de ${petController.vacinas.value.length}"),

              isThreeLine: true,
              tileColor: null,
            ),
            Row(
              children: [
                const IconeBotao(icone: Icons.arrow_back, rotulo: "Ant.").bt(() {
                  petController.navegaListVacina(-1);
                }),
                const SizedBox(width: 5),
                const IconeBotao(icone: Icons.add, rotulo: "Incluir").bt(() {
                  if(globals.idpetsel == 0){
                    Get.defaultDialog(title:"Nenhum Pet Cadastrado",
                    middleText: "Nenhum Pet Cadastrado!",
                        confirmTextColor: Colors.white,
                        textConfirm: "Confirmar",
                        buttonColor:Colors.red,
                        onConfirm:() {
                            Get.back();
                         });
                  }
                  else{
                    Get.toNamed('/cadastroVacina');
                    petController.refreshVacina();
                  }

                }),
                 const SizedBox(width: 5),
                const IconeBotao(icone: Icons.list_alt, rotulo: "List.").bt(() {
                  Get.toNamed('/listarVacinasPet');
                }),
                const SizedBox(width: 5),
                const IconeBotao(icone: Icons.arrow_forward, rotulo: "Prox.").bt(() {
                  petController.navegaListVacina(1);
                }),
                const SizedBox(width: 5),

              ],
            ),
            const SizedBox(height: 5),
          ],
        ));
  }

  Widget cardaviso(PetController petController) {
    return Card(
        shadowColor: Colors.orange,
        elevation: 10.0,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            ListTile(
              title: Text(
                  "Aviso:" + petController.aviso.value.nomeaviso.toString()),
              subtitle: Text("Data do Aviso:" +
                  petController.aviso.value.datavencimento.toString() +
                  "\nData do Cadastro: " +
                  petController.aviso.value.datacadastro.toString() +
                  "\n\nAviso ${(petController.indexAviso.value + 1)} de ${petController.avisos.value.length}"),
              isThreeLine: true,
              tileColor: null,
            ),
            Row(
              //  mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const IconeBotao(icone: Icons.arrow_back, rotulo: "Ant.").bt(() {
                  petController.navegaListAviso(-1);
                }),
                const SizedBox(width: 5),
                const IconeBotao(icone: Icons.add, rotulo: "Incluir").bt(() {
                  if(globals.idpetsel == 0){
                    Get.defaultDialog(title:"Nenhum Pet Cadastrado",
                        middleText: "Nenhum Pet Cadastrado!",
                        confirmTextColor: Colors.white,
                        textConfirm: "Confirmar",
                        buttonColor:Colors.red,
                        onConfirm:() {
                          Get.back();
                        });
                  }
                  else{
                    Get.toNamed('/cadastroAviso');
                    petController.refreshVacina();
                  }
                }),
                const SizedBox(width: 5),
                const IconeBotao(icone: Icons.list_alt, rotulo: "List.").bt(() {
                  Get.toNamed('/listarAvisosPet');
                }),
                const SizedBox(width: 5),
                const IconeBotao(icone: Icons.arrow_forward, rotulo: "Prox.").bt(() {
                  petController.navegaListAviso(1);
                }),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ));
  }
}
