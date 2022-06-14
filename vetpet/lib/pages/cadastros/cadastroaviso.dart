
import 'package:flutter/material.dart';
import 'package:vetpet/componentes/editordate.dart';
import 'package:vetpet/componentes/editortexto.dart';

import '../../componentes/cardpetselecionado.dart';
import '../../constantes/constantes.dart';

import '../../controller/avisocontroller.dart';

import '../../model/aviso.dart';
import '../../model/globals.dart' as globals;
import 'package:get/get.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CadastroAviso extends StatelessWidget {
  late final int idvacina;

  final _formKey = GlobalKey<FormState>();
  late String imgString = "";

  late Aviso aviso = Aviso(0, globals.idpetsel, "", "", "", "");
  late bool buscaaviso = true;
  final avisoController = Get.put(AvisoController());

  CadastroAviso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avisoController.idaviso.value > 0 && buscaaviso) {
      avisoController.selecionaAviso(  avisoController.idaviso.value);
      buscaaviso = false;
    }
    return Scaffold(
        appBar: AppBar( backgroundColor: COLOR_ORANGE,
          title:  avisoController.idaviso.value == 0
              ? const Text("Cadastrar Aviso")
              : const Text("Editar Aviso"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              CardPetSelecionado(),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      EditorTexto(avisoController.controladorNomeAviso,
                          rotulo: "Aviso",
                          dica: "Nome do Aviso",
                          icone: Icons.medical_services,
                          obrigatorio: true,
                          listaOP: 2),
                      EditorDate(avisoController.controladordatacadastro,
                          rotulo: "Data da Aplicação",
                          dica: "DD/MM/YYYY",
                          icone: Icons.calendar_today,
                          teclado: TextInputType.datetime,
                          obrigatorio: true),
                      EditorDate(avisoController.controladordataaviso,
                          rotulo: "Data de Retorno",
                          dica: "DD/MM/YYYY",
                          icone: Icons.calendar_today,
                          teclado: TextInputType.datetime,
                          obrigatorio: true),
                      EditorTexto(
                        avisoController.controladordescricao,
                        rotulo: "Descrição",
                      ),
                      CheckboxListTile(
                        title: const Text("Inativar noticicações"),
                        checkColor: Colors.white,
                        value: avisoController.isChecked.value,
                        selected: false,
                        onChanged: avisoController.idaviso.value == 0
                            ? null
                            : (bool? newValue)
                        {
                          avisoController.isChecked.value = newValue!;
                          FirebaseCrashlytics.instance
                              .log('This is a log example');
                          Get.forceAppUpdate();
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          avisoController.idaviso.value > 0 ? ElevatedButton(
                            child: const Text(textoBotaoExcluir),
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.red)),
                            onPressed: () => _deleteVacina(avisoController.idaviso.value ),
                          )

                              : const Text(""),

                          Text(avisoController.idaviso.value > 0
                              ? "    "
                              : ""),
                          ElevatedButton(
                            child: const Text(textoBotaoConfirmar),
                            onPressed: () => _cadastrarVacina(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }

  Future<void> _cadastrarVacina(BuildContext context) async {
    final int idpet = globals.idpetsel;
    if (_formKey.currentState!.validate() && idpet != 0) {
      if (avisoController.idaviso > 0) {
        avisoController.atualiza();
      } else {
        avisoController.adicionar();
      }
      Get.back();
    } else {
      if (idpet == 0) {
        Get.defaultDialog(title: "Selecione o Pet",
            textCustom: 'Selecione o Pet que deseja cadastrar a Vacina');
      }
    }
  }

  _deleteVacina(int id) {
    if (avisoController.idaviso.value > 0) {
      Get.defaultDialog(title:"Confirma a Operação",
          middleText: "Deseja Apagar a Vacina Selecionada?",
          cancelTextColor: Colors.red,
          textCancel: "Cancelar",
          confirmTextColor: Colors.white,
          textConfirm: "Confirmar",
          buttonColor:Colors.red,
          onCancel: (){ },
          onConfirm:() {
            avisoController.apagar(id);
            Get.back();
            Get.back();
          }
      );
    }
  }
}
